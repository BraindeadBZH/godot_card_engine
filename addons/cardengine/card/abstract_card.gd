tool
class_name AbstractCard
extends Node2D

signal instance_changed()
signal need_removal()
signal clicked()
signal state_changed(new_state)

enum CardSide {FRONT, BACK}
enum CardState {NONE, IDLE, FOCUSED, ACTIVE}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_trans: CardTransform = null
var _merge_trans: CardTransform = null
var _transitions: CardTransitions = CardTransitions.new()
var _remove_flag: bool = false
var _state = CardState.NONE
var _rng: PseudoRng = PseudoRng.new()
var _interactive: bool = true
var _interaction_paused: bool = false
var _anim: AnimationData = AnimationData.new("empty", "Empty")
var _current_anim: String = ""
var _anim_queue: Array = []
var _trans_origin: CardTransform = CardTransform.new()
var _trans_focused: CardTransform = CardTransform.new()
var _trans_activated: CardTransform = CardTransform.new()

onready var _cont = $AnimContainer
onready var _front = $AnimContainer/Front
onready var _back  = $AnimContainer/Back
onready var _transi = $Transitions
onready var _mergeWin = $MergeWindow
onready var _anim_player = $AnimationPlayer


func _process(delta: float) -> void:
	if _anim_queue.empty() or _interaction_paused:
		return
		
	var next = _anim_queue.front()

	if _current_anim != "idle" and next == "idle" and _anim_player.is_active():
		return
	
	match next:
		"idle":
			_change_state(CardState.IDLE)
		"focused":
			_change_state(CardState.FOCUSED)
		"activated":
			_change_state(CardState.ACTIVE)
		"deactivated":
			_change_state(CardState.FOCUSED)
		"unfocused":
			_change_state(CardState.IDLE)
	
	_anim_queue.pop_front()
	_change_anim(next)


func set_instance(inst: CardInstance) -> void:
	_inst = inst
	emit_signal("instance_changed")


func instance() -> CardInstance:
	return _inst


func root_trans() -> CardTransform:
	return _root_trans


func set_root_trans(transform: CardTransform) -> void:
	_mergeWin.stop()
	_mergeWin.start()
	
	_merge_trans = transform


func set_root_trans_immediate(transform: CardTransform) -> void:
	_root_trans = transform
	position = transform.pos
	scale = transform.scale
	rotation = transform.rot
	
	_change_anim("idle")


func transitions() -> CardTransitions:
	return _transitions


func set_transitions(transitions: CardTransitions):
	_transitions = transitions


func side() -> int:
	return _side


func set_side(side_up: int) -> void:
	if _side == side_up:
		return
	
	if side_up == CardSide.FRONT:
		_side = CardSide.FRONT
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.BACK:
		_side = CardSide.BACK
		_front.visible = false
		_back.visible = true


func change_side() -> void:
	if _side == CardSide.FRONT:
		set_side(CardSide.BACK)
	else:
		set_side(CardSide.FRONT)


func set_interactive(state: bool) -> void:
	_interactive = state


func set_interaction_paused(state: bool) -> void:
	_interaction_paused = state


func set_animation(anim: AnimationData) -> void:
	if anim == null:
		_anim_player.remove_all()
	
	_cont.position = Vector2(0.0, 0.0)
	_cont.scale = Vector2(1.0, 1.0)
	_cont.rotation = 0.0
	_state = CardState.NONE
	_anim = anim
	_current_anim = ""
	_anim_queue.clear()
	_change_anim("idle")


func is_flagged_for_removal() -> bool:
	return _remove_flag


func flag_for_removal() -> void:
	_remove_flag = true
	
	if _transitions.out_anchor.enabled:
		_transi.remove_all()

		_transi.interpolate_property(
			self, "position", position, _transitions.out_anchor.position,
			_transitions.out_anchor.duration,
			_transitions.out_anchor.type,
			_transitions.out_anchor.easing)

		_transi.interpolate_property(
			self, "scale", scale, _transitions.out_anchor.scale,
			_transitions.out_anchor.duration,
			_transitions.out_anchor.type,
			_transitions.out_anchor.easing)

		_transi.interpolate_property(
			self, "rotation", rotation, _transitions.out_anchor.rotation,
			_transitions.out_anchor.duration,
			_transitions.out_anchor.type,
			_transitions.out_anchor.easing)
		
		_transi.start()
	else:
		emit_signal("need_removal")


func _setup_pos_sequence(seq: PositionSequence, player: Tween) -> Vector2:
	var prev_val: Vector2 = Vector2(0.0, 0.0)
	var delay: float = 0.0
	
	match seq.from_mode():
		AnimationSequence.INIT_ORIGIN:
			prev_val = Vector2(0.0, 0.0)
		AnimationSequence.INIT_FOCUSED:
			prev_val = _trans_focused.pos
		AnimationSequence.INIT_ACTIVATED:
			prev_val = _trans_activated.pos
	
	if seq.from_mode() == AnimationSequence.INIT_ORIGIN:
		prev_val = Vector2(0.0, 0.0)

	for step in seq.sequence():
		if step.transi != null:
			var final_pos: Vector2 = Vector2(0.0, 0.0)
			var final_duration: float = step.transi.duration

			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)

			match step.val.mode:
				StepValue.Mode.INITIAL:
					match seq.to_mode():
						AnimationSequence.INIT_ORIGIN:
							final_pos = Vector2(0.0, 0.0)
						AnimationSequence.INIT_FOCUSED:
							final_pos = _trans_focused.pos
						AnimationSequence.INIT_ACTIVATED:
							final_pos = _trans_activated.pos
				StepValue.Mode.FIXED:
					final_pos = step.val.vec_val
				StepValue.Mode.RANDOM:
					final_pos = _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", true)
			
			player.interpolate_property(
				_cont, "position",
				prev_val, final_pos,
				final_duration, step.transi.type, step.transi.easing, delay)

			prev_val = final_pos
			delay += final_duration

			if step.transi.flip_card:
				player.interpolate_callback(self, delay, "change_side")
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", false)
	
	return prev_val


func _setup_scale_sequence(seq: ScaleSequence, player: Tween) -> Vector2:
	var prev_val: Vector2 = Vector2(1.0, 1.0)
	var delay: float = 0.0
	
	match seq.from_mode():
		AnimationSequence.INIT_ORIGIN:
			prev_val = Vector2(1.0, 1.0)
		AnimationSequence.INIT_FOCUSED:
			prev_val = _trans_focused.scale
		AnimationSequence.INIT_ACTIVATED:
			prev_val = _trans_activated.scale

	for step in seq.sequence():
		if step.transi != null:
			var final_scale: Vector2 = Vector2(1.0, 1.0)
			var final_duration: float = step.transi.duration

			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)

			match step.val.mode:
				StepValue.Mode.INITIAL:
					match seq.to_mode():
						AnimationSequence.INIT_ORIGIN:
							final_scale = Vector2(1.0, 1.0)
						AnimationSequence.INIT_FOCUSED:
							final_scale = _trans_focused.scale
						AnimationSequence.INIT_ACTIVATED:
							final_scale = _trans_activated.scale
				StepValue.Mode.FIXED:
					final_scale = step.val.vec_val
				StepValue.Mode.RANDOM:
					final_scale = _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", true)
			
			player.interpolate_property(
				_cont, "scale",
				prev_val, final_scale,
				final_duration, step.transi.type, step.transi.easing, delay)

			prev_val = final_scale
			delay += final_duration

			if step.transi.flip_card:
				player.interpolate_callback(self, delay, "change_side")
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", false)
	
	return prev_val


func _setup_rotation_sequence(seq: RotationSequence, player: Tween) -> float:
	var prev_val: float = 0.0
	var delay: float = 0.0
	
	match seq.from_mode():
		AnimationSequence.INIT_ORIGIN:
			prev_val = 0.0
		AnimationSequence.INIT_FOCUSED:
			prev_val = _trans_focused.rot
		AnimationSequence.INIT_ACTIVATED:
			prev_val = _trans_activated.rot

	for step in seq.sequence():
		if step.transi != null:
			var final_rot: float = 0.0
			var final_duration: float = step.transi.duration

			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)

			match step.val.mode:
				StepValue.Mode.INITIAL:
					match seq.to_mode():
						AnimationSequence.INIT_ORIGIN:
							final_rot = 0.0
						AnimationSequence.INIT_FOCUSED:
							final_rot = _trans_focused.rot
						AnimationSequence.INIT_ACTIVATED:
							final_rot = _trans_activated.rot
				StepValue.Mode.FIXED:
					final_rot = deg2rad(step.val.num_val)
				StepValue.Mode.RANDOM:
					final_rot = deg2rad(_rng.randomf_range(
						step.val.num_val, step.val.num_range))
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", true)

			player.interpolate_property(
				_cont, "rotation",
				prev_val, final_rot,
				final_duration, step.transi.type, step.transi.easing, delay)

			prev_val = final_rot
			delay += final_duration

			if step.transi.flip_card:
				player.interpolate_callback(self, delay, "change_side")
			
			if not step.transi.interactive:
				player.interpolate_callback(self, delay, "set_interaction_paused", false)
	
	return prev_val


func _change_state(new_state) -> void:
	if new_state == _state:
		return
	
	_state = new_state
	emit_signal("state_changed", new_state)


func _change_anim(anim: String) -> void:
	if _anim == null:
		return
	
	_anim_player.remove_all()
	_anim_player.repeat = false
	_current_anim = anim
	
	match anim:
		"idle":
			_anim_player.repeat = true
			
			_setup_pos_sequence(
				_anim.idle_loop().position_sequence(),
				_anim_player)
				
			_setup_scale_sequence(
				_anim.idle_loop().scale_sequence(),
				_anim_player)
				
			_setup_rotation_sequence(
				_anim.idle_loop().rotation_sequence(),
				_anim_player)
			
		"focused":
			_trans_focused.pos = _setup_pos_sequence(
				_anim.focused_animation().position_sequence(),
				_anim_player)
				
			_trans_focused.scale = _setup_scale_sequence(
				_anim.focused_animation().scale_sequence(),
				_anim_player)
				
			_trans_focused.rot = _setup_rotation_sequence(
				_anim.focused_animation().rotation_sequence(),
				_anim_player)
				
		"activated":
			_trans_activated.pos = _setup_pos_sequence(
				_anim.activated_animation().position_sequence(),
				_anim_player)
				
			_trans_activated.scale = _setup_scale_sequence(
				_anim.activated_animation().scale_sequence(),
				_anim_player)
				
			_trans_activated.rot = _setup_rotation_sequence(
				_anim.activated_animation().rotation_sequence(),
				_anim_player)
				
		"deactivated":
			_setup_pos_sequence(
				_anim.deactivated_animation().position_sequence(),
				_anim_player)
				
			_setup_scale_sequence(
				_anim.deactivated_animation().scale_sequence(),
				_anim_player)
				
			_setup_rotation_sequence(
				_anim.deactivated_animation().rotation_sequence(),
				_anim_player)
				
		"unfocused":
			_setup_pos_sequence(
				_anim.unfocused_animation().position_sequence(),
				_anim_player)
				
			_setup_scale_sequence(
				_anim.unfocused_animation().scale_sequence(),
				_anim_player)
				
			_setup_rotation_sequence(
				_anim.unfocused_animation().rotation_sequence(),
				_anim_player)
			
	_anim_player.start()


func _on_MouseArea_mouse_entered() -> void:
	if not _interactive:
		return
	
	z_index = 1
	
	_anim_queue.push_back("focused")


func _on_MouseArea_mouse_exited() -> void:
	if not _interactive:
		return
	
	z_index = 0
	
	_anim_queue.push_back("unfocused")
	_anim_queue.push_back("idle")


func _on_MouseArea_pressed() -> void:
	if not _interactive:
		return
	
	emit_signal("clicked")


func _on_MouseArea_button_down() -> void:
	if not _interactive:
		return
	
	_anim_queue.push_back("activated")


func _on_MouseArea_button_up() -> void:
	if not _interactive:
		return
		
	_anim_queue.push_back("deactivated")


func _on_MergeWindow_timeout() -> void:
	if _root_trans == null:
		if _transitions.in_anchor.enabled:
			_transi.remove_all()
			
			position = _transitions.in_anchor.position
			scale = _transitions.in_anchor.scale
			rotation = _transitions.in_anchor.rotation

			_transi.interpolate_property(
				self, "position", position, _merge_trans.pos,
				_transitions.in_anchor.duration,
				_transitions.in_anchor.type,
				_transitions.in_anchor.easing)

			_transi.interpolate_property(
				self, "scale", scale, _merge_trans.scale,
				_transitions.in_anchor.duration,
				_transitions.in_anchor.type,
				_transitions.in_anchor.easing)

			_transi.interpolate_property(
				self, "rotation", rotation, _merge_trans.rot,
				_transitions.in_anchor.duration,
				_transitions.in_anchor.type,
				_transitions.in_anchor.easing)
			
			_transi.start()
		else:
			position = _merge_trans.pos
			scale = _merge_trans.scale
			rotation = _merge_trans.rot
	else:
		if _root_trans.eq(_merge_trans):
			return
		
		_transi.remove_all()

		_transi.interpolate_property(
			self, "position", _root_trans.pos, _merge_trans.pos,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)

		_transi.interpolate_property(
			self, "scale", _root_trans.scale, _merge_trans.scale,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)

		_transi.interpolate_property(
			self, "rotation", _root_trans.rot, _merge_trans.rot,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)
		
		_transi.start()
	
	_root_trans = _merge_trans
	_change_anim("idle")


func _on_Transitions_tween_all_completed() -> void:
	if _remove_flag:
		emit_signal("need_removal")

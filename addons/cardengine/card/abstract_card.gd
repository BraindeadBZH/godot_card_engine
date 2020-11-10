tool
class_name AbstractCard
extends Node2D

signal instance_changed()
signal need_removal()
signal clicked()
signal state_changed(new_state)

enum CardSide {FRONT, BACK}
enum CardState {NONE, IDLE, FOCUSED, PRESSED}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_trans: CardTransform = null
var _merge_trans: CardTransform = null
var _transitions: CardTransitions = CardTransitions.new()
var _remove_flag: bool = false
var _flip_started: bool = false
var _state = CardState.NONE
var _rng: PseudoRng = PseudoRng.new()
var _interactive: bool = true

onready var _front = $Front
onready var _back  = $Back
onready var _mouse = $MouseArea
onready var _transi = $Transitions
onready var _mergeWin = $MergeWindow
onready var _flip = $FlipAnim
onready var _anim_player = $AnimPlayer


func _ready() -> void:
	_transi.start()
	_flip.start()


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


func flip() -> void:
	_flip.remove_all()
	_flip.interpolate_property(
		self, "scale", scale, Vector2(0.0, scale.y),
		_transitions.flip_start.duration,
		_transitions.flip_start.type,
		_transitions.flip_start.easing)
	_flip.start()
	
	_flip_started = true


func set_interactive(state: bool) -> void:
	_interactive = state


func change_anim(anim: AnimationData, repeat: bool = false) -> void:
		_anim_player.stop_all()
		_anim_player.remove_all()
		_anim_player.repeat = repeat
		
		position = _root_trans.pos
		scale = _root_trans.scale
		rotation = _root_trans.rot
		
		if anim != null:
			_setup_pos_anim(anim)
			_setup_scale_anim(anim)
			_setup_rotation_anim(anim)
			_anim_player.start()


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


func _setup_pos_anim(anim: AnimationData) -> void:
	var prev_val: Vector2 = _root_trans.pos
	var delay: float = 0.0
	
	for step in anim.position_seq():
		if step.transi != null:
			var final_pos = _root_trans.pos + step.val.vec_val
			var final_duration = step.transi.duration
			
			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)
			
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_pos = _root_trans.pos
				StepValue.Mode.RANDOM:
					final_pos = _root_trans.pos + _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			_anim_player.interpolate_property(
				self, "position",
				prev_val, final_pos,
				final_duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_pos
			delay += final_duration


func _setup_scale_anim(anim: AnimationData) -> void:
	var prev_val: Vector2 = _root_trans.scale
	var delay: float = 0.0
	
	for step in anim.scale_seq():
		if step.transi != null:
			var final_scale = _root_trans.scale * step.val.vec_val
			var final_duration = step.transi.duration
			
			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)
			
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_scale = _root_trans.scale
				StepValue.Mode.RANDOM:
					final_scale = _root_trans.scale * _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			_anim_player.interpolate_property(
				self, "scale",
				prev_val, final_scale,
				final_duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_scale
			delay += final_duration


func _setup_rotation_anim(anim: AnimationData) -> void:
	var prev_val: float = _root_trans.rot
	var delay: float = 0.0
	
	for step in anim.rotation_seq():
		if step.transi != null:
			var final_rot = _root_trans.rot + deg2rad(step.val.num_val)
			var final_duration = step.transi.duration
			
			if step.transi.random_duration:
				final_duration = _rng.randomf_range(
					step.transi.duration_range_min, step.transi.duration_range_max)
			
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_rot = deg2rad(_root_trans.rot)
				StepValue.Mode.RANDOM:
					final_rot = _root_trans.rot + deg2rad(_rng.randomf_range(
						step.val.num_val, step.val.num_range))
			
			_anim_player.interpolate_property(
				self, "rotation",
				prev_val, final_rot,
				final_duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_rot
			delay += final_duration


func _change_state(new_state) -> void:
	if new_state == _state:
		return
	
	_state = new_state
	emit_signal("state_changed", new_state)


func _on_MouseArea_mouse_entered() -> void:
	if not _interactive:
		return
		
	_change_state(CardState.FOCUSED)


func _on_MouseArea_mouse_exited() -> void:
	if not _interactive:
		return
		
	_change_state(CardState.IDLE)


func _on_MouseArea_pressed() -> void:
	if not _interactive:
		return
	
	emit_signal("clicked")


func _on_MouseArea_button_down() -> void:
	if not _interactive:
		return
	
	_change_state(CardState.PRESSED)


func _on_MouseArea_button_up() -> void:
	if not _interactive:
		return
		
	if _mouse.is_hovered():
		_change_state(CardState.FOCUSED)
	else:
		_change_state(CardState.IDLE)


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
	_change_state(CardState.IDLE)


func _on_Transitions_tween_all_completed() -> void:
	if _remove_flag:
		emit_signal("need_removal")


func _on_FlipAnim_tween_all_completed() -> void:
	if _flip_started:
		_flip_started = false
		
		change_side()
		
		_flip.remove_all()
		_flip.interpolate_property(
			self, "scale", scale, _root_trans.scale,
			_transitions.flip_end.duration,
			_transitions.flip_end.type,
			_transitions.flip_end.easing)
		_flip.start()

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

var _container: String = ""
var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_trans: CardTransform = null
var _merge_trans: CardTransform = null
var _adjusted_trans: CardTransform = null
var _adjust_on_focused: bool = false
var _adjust_on_activated: bool = false
var _transitions: CardTransitions = CardTransitions.new()
var _remove_flag: bool = false
var _state = CardState.NONE
var _rng: PseudoRng = PseudoRng.new()
var _interactive: bool = true
var _interaction_paused: bool = false
var _anim: AnimationData = AnimationData.new("empty", "Empty")
var _current_anim: String = ""
var _event_queue: Array = []
var _trans_origin: CardTransform = CardTransform.new()
var _trans_focused: CardTransform = CardTransform.new()
var _trans_activated: CardTransform = CardTransform.new()
var _is_dragged: bool = false
var _follow_mouse: bool = false
var _waiting_card_return: bool = false

onready var _cont = $AnimContainer
onready var _placeholder = $AnimContainer/Placeholder
onready var _front = $AnimContainer/Front
onready var _back  = $AnimContainer/Back
onready var _transi = $Transitions
onready var _transi_merge = $TransiMerge
onready var _anim_player = $AnimationPlayer
onready var _event_merge = $EventMerge
onready var _mouse = $AnimContainer/MouseArea


func _ready() -> void:
	CardEngine.general().connect("drag_stopped", self, "_on_drag_stopped")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _is_dragged and _follow_mouse:
		position += event.relative


func set_instance(inst: CardInstance) -> void:
	_inst = inst
	_update_visibility()
	emit_signal("instance_changed")


func instance() -> CardInstance:
	return _inst


func set_container(id: String) -> void:
	_container = id


func container() -> String:
	return _container


func root_trans() -> CardTransform:
	return _root_trans


func set_root_trans(transform: CardTransform) -> void:
	_transi_merge.stop()
	_transi_merge.start()

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


func set_adjusted_trans(transform: CardTransform, on_focused: bool, on_activated: bool) -> void:
	_adjusted_trans = transform
	_adjust_on_focused = on_focused
	_adjust_on_activated = on_activated


func side() -> int:
	return _side


func set_side(side_up: int) -> void:
	if _side == side_up:
		return

	_side = side_up
	_update_visibility()


func change_side() -> void:
	if _side == CardSide.FRONT:
		set_side(CardSide.BACK)
	else:
		set_side(CardSide.FRONT)


func set_interactive(state: bool) -> void:
	_interactive = state


func set_interaction_paused(state: bool) -> void:
	_interaction_paused = state


func set_drag_enabled(state: bool) -> void:
	_mouse.set_drag_enabled(state)


func set_animation(anim: AnimationData) -> void:
	if anim == null:
		_anim_player.remove_all()

	_cont.position = Vector2(0.0, 0.0)
	_cont.scale = Vector2(1.0, 1.0)
	_cont.rotation = 0.0
	_state = CardState.NONE
	_anim = anim
	_current_anim = ""
	_event_queue.clear()
	_precompute_trans()
	_change_anim("idle")


func set_drag_widget(scene: PackedScene) -> void:
	_mouse.set_drag_widget(scene)
	if scene == null:
		_follow_mouse = true
	else:
		_follow_mouse = false


func is_flagged_for_removal() -> bool:
	return _remove_flag


func flag_for_removal() -> void:
	_remove_flag = true

	if _transitions.out_anchor.enabled:
		_transition(_current_trans(), null)
	else:
		emit_signal("need_removal")


func _update_visibility() -> void:
	if _inst == null:
		_placeholder.visible = true
		_back.visible = false
		_front.visible = false
		return
	else:
		_placeholder.visible = false

	if _side == CardSide.FRONT:
		_back.visible = false
		_front.visible = true
	elif _side == CardSide.BACK:
		_front.visible = false
		_back.visible = true


func _current_trans() -> CardTransform:
	var trans = CardTransform.new()

	trans.pos = position
	trans.scale = scale
	trans.rot = rotation

	return trans


func _transition(from: CardTransform, to: CardTransform) -> void:
	var duration: float = _transitions.order.duration
	var type: int = _transitions.order.type
	var easing: int = _transitions.order.easing

	if from == null:
		from = CardTransform.new()
		from.pos = _transitions.in_anchor.position
		from.scale = _transitions.in_anchor.scale
		from.rot = _transitions.in_anchor.rotation

		duration = _transitions.in_anchor.duration
		type = _transitions.in_anchor.type
		easing = _transitions.in_anchor.easing

	if to == null:
		to = CardTransform.new()
		to.pos = _transitions.out_anchor.position
		to.scale = _transitions.out_anchor.scale
		to.rot = _transitions.out_anchor.rotation

		duration = _transitions.out_anchor.duration
		type = _transitions.out_anchor.type
		easing = _transitions.out_anchor.easing

	position = from.pos
	scale = from.scale
	rotation = from.rot

	_transi.remove_all()

	_transi.interpolate_property(
		self, "position", from.pos, to.pos, duration, type, easing)

	_transi.interpolate_property(
		self, "scale", from.scale, to.scale, duration, type, easing)

	_transi.interpolate_property(
		self, "rotation", from.rot, to.rot, duration, type, easing)

	_transi.start()


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


func _precompute_trans() -> void:
	if _anim == null:
		return

	_trans_focused.pos = _setup_pos_sequence(
		_anim.focused_animation().position_sequence(),
		_anim_player)

	_trans_focused.scale = _setup_scale_sequence(
		_anim.focused_animation().scale_sequence(),
		_anim_player)

	_trans_focused.rot = _setup_rotation_sequence(
		_anim.focused_animation().rotation_sequence(),
		_anim_player)

	_trans_activated.pos = _setup_pos_sequence(
		_anim.activated_animation().position_sequence(),
		_anim_player)

	_trans_activated.scale = _setup_scale_sequence(
		_anim.activated_animation().scale_sequence(),
		_anim_player)

	_trans_activated.rot = _setup_rotation_sequence(
		_anim.activated_animation().rotation_sequence(),
		_anim_player)


func _change_state(new_state: int) -> void:
	if new_state == _state:
		return

	_state = new_state
	emit_signal("state_changed", new_state)


func _change_anim(anim: String) -> void:
	if _anim == null or _remove_flag:
		return

	_anim_player.remove_all()
	_anim_player.repeat = false
	_current_anim = anim

	match anim:
		"idle":
			_anim_player.repeat = true

			_cont.position = Vector2(0.0, 0.0)
			_cont.scale = Vector2(1.0, 1.0)
			_cont.rotation = 0.0

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
			if _adjust_on_focused and _adjusted_trans != null:
				_transition(_root_trans, _adjusted_trans)

			_cont.position = Vector2(0.0, 0.0)
			_cont.scale = Vector2(1.0, 1.0)
			_cont.rotation = 0.0

			_setup_pos_sequence(
				_anim.focused_animation().position_sequence(),
				_anim_player)

			_setup_scale_sequence(
				_anim.focused_animation().scale_sequence(),
				_anim_player)

			_setup_rotation_sequence(
				_anim.focused_animation().rotation_sequence(),
				_anim_player)

		"activated":
			if _adjust_on_activated and _adjusted_trans != null:
				_transition(_root_trans, _adjusted_trans)

			_cont.position = _trans_focused.pos
			_cont.scale = _trans_focused.scale
			_cont.rotation = _trans_focused.rot

			_setup_pos_sequence(
				_anim.activated_animation().position_sequence(),
				_anim_player)

			_setup_scale_sequence(
				_anim.activated_animation().scale_sequence(),
				_anim_player)

			_setup_rotation_sequence(
				_anim.activated_animation().rotation_sequence(),
				_anim_player)

		"deactivated":
			if _adjust_on_activated and _adjusted_trans != null:
				_transition(_adjusted_trans, _root_trans)

			_cont.position = _trans_activated.pos
			_cont.scale = _trans_activated.scale
			_cont.rotation = _trans_activated.rot

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
			if _adjust_on_focused and _adjusted_trans != null:
				_transition(_adjusted_trans, _root_trans)

			_cont.position = _trans_focused.pos
			_cont.scale = _trans_focused.scale
			_cont.rotation = _trans_focused.rot

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


func _post_event(event: String) -> void:
	_event_queue.push_back(event)


func _merge_events() -> void:
	var merged := []
	var prev = ""

	for event in _event_queue:
		if prev != event:
			var need_merge = false

			if event == "focused" && prev == "unfocused":
				need_merge = true
			elif event == "unfocused" && prev == "focused":
				need_merge = true
			elif event == "activated" && prev == "deactivated":
				need_merge = true
			elif event == "deactivated" && prev == "activated":
				need_merge = true

			if need_merge:
				merged.pop_back()
				if not merged.empty():
					prev = merged.back()
				else:
					prev = ""
			else:
				merged.push_back(event)
				prev = event

	_event_queue = merged


func _on_EventMerge_timeout() -> void:
	_merge_events()

	if _event_queue.empty() or _interaction_paused:
		return

	var next = _event_queue.front()

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

	_event_queue.pop_front()
	_change_anim(next)


func _on_MouseArea_mouse_entered() -> void:
	if not _interactive or CardEngine.general().is_dragging():
		return

	z_index = 1

	_post_event("focused")


func _on_MouseArea_mouse_exited() -> void:
	if not _interactive or CardEngine.general().is_dragging():
		return

	z_index = 0

	_post_event("unfocused")
	_post_event("idle")


func _on_MouseArea_pressed() -> void:
	if not _interactive or CardEngine.general().is_dragging():
		return

	emit_signal("clicked")


func _on_MouseArea_button_down() -> void:
	if not _interactive or CardEngine.general().is_dragging():
		return

	_post_event("activated")


func _on_MouseArea_button_up() -> void:
	if not _interactive or CardEngine.general().is_dragging():
		return

	_post_event("deactivated")


func _on_TransiMerge_timeout() -> void:
	if _root_trans == null:
		if _transitions.in_anchor.enabled:
			_transition(null, _merge_trans)
		else:
			position = _merge_trans.pos
			scale = _merge_trans.scale
			rotation = _merge_trans.rot
	else:
		if _root_trans.eq(_merge_trans):
			return

		_transition(_root_trans, _merge_trans)

	_root_trans = _merge_trans
	_change_anim("idle")


func _on_Transitions_tween_all_completed() -> void:
	if _remove_flag:
		emit_signal("need_removal")

	if _waiting_card_return:
		_waiting_card_return = false
		_mouse.mouse_filter = Control.MOUSE_FILTER_STOP

		_post_event("unfocused")
		_post_event("idle")


func _on_MouseArea_drag_started() -> void:
	CardEngine.general().start_drag(_inst, _container)
	_is_dragged = true

	if _follow_mouse:
		_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_drag_stopped() -> void:
	if _is_dragged:
		z_index = 0
		_is_dragged = false

		if _remove_flag:
			return

		if _follow_mouse:
			_waiting_card_return = true

			if _adjusted_trans != null:
				_transition(_current_trans(), _adjusted_trans)
			else:
				_transition(_current_trans(), _root_trans)
		else:
			_post_event("deactivated")

			if not _mouse.is_hovered():
				_post_event("unfocused")
				_post_event("idle")

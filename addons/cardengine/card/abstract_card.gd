class_name AbstractCard
extends Node2D

signal instance_changed()
signal need_removal()

enum CardSide {FRONT, BACK}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_trans: CardTransform = null
var _merge_trans: CardTransform = null
var _transitions: CardTransitions = CardTransitions.new()
var _remove_flag: bool = false

onready var _front = $Front
onready var _back  = $Back
onready var _transi = $Transitions
onready var _mergeWin = $MergeWindow


func _ready() -> void:
	_transi.start()


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


func transitions() -> CardTransitions:
	return _transitions


func set_transitions(transitions: CardTransitions):
	_transitions = transitions


func side() -> int:
	return _side


func flip(side_up: int) -> void:
	if side_up == CardSide.FRONT:
		_side = CardSide.FRONT
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.BACK:
		_side = CardSide.BACK
		_front.visible = false
		_back.visible = true


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


func _mouse_click() -> void:
	pass


func _on_MouseArea_mouse_entered() -> void:
	pass
#	print("Mouse entered ", _data.id)


func _on_MouseArea_mouse_exited() -> void:
	pass
#	print("Mouse exited ", _data.id)


func _on_MouseArea_pressed() -> void:
	_mouse_click()


func _on_MouseArea_button_down() -> void:
	print("Mouse pressed ", _inst.data().id)


func _on_MouseArea_button_up() -> void:
	print("Mouse released ", _inst.data().id)


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


func _on_Transitions_tween_all_completed() -> void:
	if _remove_flag:
		emit_signal("need_removal")

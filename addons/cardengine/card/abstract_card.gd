class_name AbstractCard
extends Node2D

signal instance_changed()

enum CardSide {FRONT, BACK}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_state: CardState = null
var _merge_state: CardState = null
var _transitions: CardTransitions = CardTransitions.new()

onready var _front = $Front
onready var _back  = $Back
onready var _trans = $Transitions
onready var _mergeWin = $MergeWindow


func _ready() -> void:
	_trans.start()


func side() -> int:
	return _side


func root_state() -> CardState:
	return _root_state


func set_instance(inst: CardInstance) -> void:
	_inst = inst
	emit_signal("instance_changed")


func instance() -> CardInstance:
	return _inst


func flip(side_up: int) -> void:
	if side_up == CardSide.FRONT:
		_side = CardSide.FRONT
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.BACK:
		_side = CardSide.BACK
		_front.visible = false
		_back.visible = true


func set_root_state(state: CardState) -> void:
	_mergeWin.stop()
	_mergeWin.start()
	
	_merge_state = state


func set_transitions(transitions: CardTransitions):
	_transitions = transitions


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
	if _root_state == null:
		position = _merge_state.pos
		scale = _merge_state.scale
		rotation = _merge_state.rot
	else:
		if _root_state.eq(_merge_state):
			return
		
		_trans.remove_all()

		_trans.interpolate_property(
			self, "position", _root_state.pos, _merge_state.pos,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)

		_trans.interpolate_property(
			self, "scale", _root_state.scale, _merge_state.scale,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)

		_trans.interpolate_property(
			self, "rotation", _root_state.rot, _merge_state.rot,
			_transitions.order.duration,
			_transitions.order.type,
			_transitions.order.easing)
		
		_trans.start()
	
	_root_state = _merge_state

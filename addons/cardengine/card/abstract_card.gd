class_name AbstractCard
extends Node2D

signal instance_changed()

enum CardSide {FRONT, BACK}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _inst: CardInstance = null
var _side = CardSide.FRONT
var _root_state: CardState = null
var _order_duration: float = 0.0

onready var _front = $Front
onready var _back  = $Back
onready var _trans = $Transitions


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
	if _root_state == null:
		position = state.pos
		scale = state.scale
		rotation = state.rot
	else:
#		print("Old position ", _root_state.pos, " for ", _data.id)
#		print("New position ", state.pos, " for ", _data.id)
		
#		_trans.interpolate_property(
#			self, "position", position, state.pos,
#			_order_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#
#		_trans.interpolate_property(
#			self, "scale", scale, state.scale,
#			_order_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#
#		_trans.interpolate_property(
#			self, "rotation", rotation, state.rot,
#			_order_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		position = state.pos
		scale = state.scale
		rotation = state.rot
	
	_root_state = state


func set_transitions(order_duration: float):
	_order_duration = order_duration


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

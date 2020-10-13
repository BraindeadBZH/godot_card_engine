class_name AbstractCard
extends Node2D

signal data_changed()

enum CardSide {FRONT, BACK}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _data: CardData = null
var _side = CardSide.FRONT
var _root_state: CardState = null

onready var _front = $Front
onready var _back  = $Back
onready var _trans = $Transition


func side() -> int:
	return _side


func root_state() -> CardState:
	return _root_state



func set_data(data: CardData) -> void:
	_data = data
	emit_signal("data_changed")


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
	_root_state = state


func _mouse_click() -> void:
	pass


func _on_MouseArea_mouse_entered() -> void:
	print("Mouse entered ", _data.id)


func _on_MouseArea_mouse_exited() -> void:
	print("Mouse exited ", _data.id)


func _on_MouseArea_pressed() -> void:
	_mouse_click()


func _on_MouseArea_button_down() -> void:
	print("Mouse pressed ", _data.id)


func _on_MouseArea_button_up() -> void:
	print("Mouse released ", _data.id)

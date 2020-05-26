class_name AbstractCard
extends Node2D

signal data_changed()

enum CardSide {FRONT, BACK}

export(Vector2) var size: Vector2 = Vector2(0.0, 0.0)

var _data: CardData = null

onready var _front = $Front
onready var _back  = $Back


func flip(side_up) -> void:
	if side_up == CardSide.FRONT:
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.BACK:
		_front.visible = false
		_back.visible = true


func set_data(data: CardData):
	_data = data
	emit_signal("data_changed")

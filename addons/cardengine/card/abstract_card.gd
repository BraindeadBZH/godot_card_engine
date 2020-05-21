class_name AbstractCard
extends Node2D

enum CardSide {FRONT, BACK}

onready var _front = $Front
onready var _back  = $Back


func flip(side_up) -> void:
	if side_up == CardSide.FRONT:
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.BACK:
		_front.visible = false
		_back.visible = true

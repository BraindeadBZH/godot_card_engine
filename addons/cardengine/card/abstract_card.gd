extends Node2D
class_name AbstractCard

enum CardSide {SideFront, SideBack}

onready var _front = $Front
onready var _back  = $Back

func flip(side_up) -> void:
	if side_up == CardSide.SideFront:
		_back.visible = false
		_front.visible = true
	elif side_up == CardSide.SideBack:
		_front.visible = false
		_back.visible = true

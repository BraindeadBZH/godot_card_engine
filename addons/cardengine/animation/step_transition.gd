tool
class_name StepTransition
extends Reference

var duration: float = 0.3
var type: int = Tween.TRANS_LINEAR
var easing: int = Tween.EASE_IN

func _init(d: float, t: int, e: int) -> void:
	duration = d
	type = t
	easing = e

tool
class_name StepTransition
extends Reference

var random_duration: bool = false
var duration: float = 0.3
var duration_range_min: float = 0.1
var duration_range_max: float = 0.3
var type: int = Tween.TRANS_LINEAR
var easing: int = Tween.EASE_IN

func _init(d: float, t: int, e: int) -> void:
	duration = d
	type = t
	easing = e

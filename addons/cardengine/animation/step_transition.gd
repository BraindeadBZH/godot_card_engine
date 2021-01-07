tool
class_name StepTransition
extends Reference

var random_duration: bool = false
var duration: float = 0.3
var duration_range_min: float = 0.1
var duration_range_max: float = 0.3
var type: int = Tween.TRANS_LINEAR
var easing: int = Tween.EASE_IN
var flip_card: bool = false
var interactive: bool = true

func _init(d: float, t: int, e: int) -> void:
	duration = d
	type = t
	easing = e


func duplicate() -> StepTransition:
	var dup: StepTransition = get_script().new(duration, type, easing)
	dup.random_duration = random_duration
	dup.duration_range_min = duration_range_min
	dup.duration_range_max = duration_range_max
	dup.flip_card = flip_card

	return dup

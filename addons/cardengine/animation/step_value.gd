tool
class_name StepValue
extends Reference

enum Mode {INITIAL, FIXED, RANDOM}

var mode: int = Mode.INITIAL
var vec_val: Vector2 = Vector2(0.0, 0.0)
var num_val: float = 0.0

# For RANDOM mode range, _range values used as MAX, _val values used AS MIN
var vec_range: Vector2 = Vector2(0.0, 0.0)
var num_range: float = 0.0


func _init(m: int) -> void:
	mode = m


func duplicate() -> StepValue:
	var dup: StepValue = get_script().new(mode)
	dup.vec_val = vec_val
	dup.num_val = num_val
	dup.vec_range = vec_range
	dup.num_range = num_range

	return dup

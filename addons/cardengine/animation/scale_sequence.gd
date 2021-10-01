@tool
class_name ScaleSequence
extends AnimationSequence


func _init(from_mode: int, to_mode: int):
	super(from_mode, to_mode)


func _default_value() -> StepValue:
	var val = StepValue.new(StepValue.Mode.FIXED)
	val.vec_val = Vector2(1.0, 1.0)

	return val

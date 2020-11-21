tool
class_name AnimationStep
extends Reference

var transi: StepTransition = null
var val: StepValue = null
var editable_transi: bool = true
var editable_val: bool = true


func _init(t: StepTransition, v: StepValue, et: bool = true, ev: bool = true) -> void:
	transi = t
	val = v
	editable_transi = et
	editable_val = ev

func duplicate() -> AnimationStep:
	var step: AnimationStep = get_script().new(
		transi.duplicate(), val.duplicate(), editable_transi, editable_val)
	return step

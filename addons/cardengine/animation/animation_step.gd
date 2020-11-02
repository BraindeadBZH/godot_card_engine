tool
class_name AnimationStep
extends Reference

var transi: StepTransition = null
var val: StepValue = null
var editable: bool = true


func _init(t: StepTransition, v: StepValue, e: bool = true) -> void:
	transi = t
	val = v
	editable = e

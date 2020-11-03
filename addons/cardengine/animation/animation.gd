tool
class_name AnimationData
extends Reference

var id: String = ""
var name: String = ""

var _pos_seq: Array = []
var _scale_seq: Array = []
var _rot_seq: Array = []


func _init(id: String, name: String) -> void:
	self.id = id
	self.name = name


func init_position_seq() -> void:
		var step0 := AnimationStep.new(
			null, StepValue.new(StepValue.Mode.INITIAL), false, false)
		
		var step1 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
		
		var step2 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.INITIAL), true, false)
		
		_pos_seq.append(step0)
		_pos_seq.append(step1)
		_pos_seq.append(step2)


func clear_position_seq() -> void:
	_pos_seq.clear()


func position_seq() -> Array:
	return _pos_seq


func set_position_seq(seq: Array) -> void:
	_pos_seq = seq


func add_position_step(step: AnimationStep) -> void:
	_pos_seq.insert(_pos_seq.size()-1, step)


func remove_position_step(index: int) -> void:
	if index <= 0 and index >= _pos_seq.size()-1:
		return
	
	_pos_seq.remove(index)


func init_scale_seq() -> void:
		var step0 := AnimationStep.new(
			null, StepValue.new(StepValue.Mode.INITIAL), false, false)
		
		var step1 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
		step1.val.vec_val = Vector2(1.0, 1.0)
		
		var step2 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.INITIAL), true, false)
		
		_scale_seq.append(step0)
		_scale_seq.append(step1)
		_scale_seq.append(step2)


func clear_scale_seq() -> void:
	_scale_seq.clear()


func scale_seq() -> Array:
	return _scale_seq


func set_scale_seq(seq: Array) -> void:
	_scale_seq = seq


func add_scale_step(step: AnimationStep) -> void:
	_scale_seq.insert(_scale_seq.size()-1, step)


func remove_scale_step(index: int) -> void:
	if index <= 0 and index >= _scale_seq.size()-1:
		return
	
	_scale_seq.remove(index)


func init_rotation_seq() -> void:
		var step0 := AnimationStep.new(
			null, StepValue.new(StepValue.Mode.INITIAL), false, false)
		
		var step1 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
		
		var step2 := AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.INITIAL), true, false)
		
		_rot_seq.append(step0)
		_rot_seq.append(step1)
		_rot_seq.append(step2)


func clear_rotation_seq() -> void:
	_rot_seq.clear()


func rotation_seq() -> Array:
	return _rot_seq


func set_rotation_seq(seq: Array) -> void:
	_rot_seq = seq


func add_rotation_step(step: AnimationStep) -> void:
	_rot_seq.insert(_rot_seq.size()-1, step)


func remove_rotation_step(index: int) -> void:
	if index <= 0 and index >= _rot_seq.size()-1:
		return
	
	_rot_seq.remove(index)

tool
class_name AnimationData
extends Reference

var id: String = ""
var name: String = ""

var _pos_seq: Array = []
var _scale_seq: Array = []
var _rot_seq: Array = []
var _rng: PseudoRng = PseudoRng.new()


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


func add_position_step(step: AnimationStep = null) -> void:
	if step == null:
		step = AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
	
	_pos_seq.insert(_pos_seq.size()-1, step)


func remove_position_step(index: int) -> void:
	if index <= 0 and index >= _pos_seq.size()-1:
		return
	
	_pos_seq.remove(index)


func shift_position_step_left(index: int) -> void:
	if index <= 0 and index >= _pos_seq.size()-1:
		return
	
	Utils.shift_elt_left(_pos_seq, index)


func shift_position_step_right(index: int) -> void:
	if index <= 0 and index >= _pos_seq.size()-1:
		return
	
	Utils.shift_elt_right(_pos_seq, index)


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


func add_scale_step(step: AnimationStep = null) -> void:
	if step == null:
		step = AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
		step.val.vec_val = Vector2(1.0, 1.0)
	
	_scale_seq.insert(_scale_seq.size()-1, step)


func remove_scale_step(index: int) -> void:
	if index <= 0 and index >= _scale_seq.size()-1:
		return
	
	_scale_seq.remove(index)


func shift_scale_step_left(index: int) -> void:
	if index <= 0 and index >= _scale_seq.size()-1:
		return
	
	Utils.shift_elt_left(_scale_seq, index)


func shift_scale_step_right(index: int) -> void:
	if index <= 0 and index >= _scale_seq.size()-1:
		return
	
	Utils.shift_elt_right(_scale_seq, index)


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


func add_rotation_step(step: AnimationStep = null) -> void:
	if step == null:
		step = AnimationStep.new(
			StepTransition.new(0.3, Tween.TRANS_LINEAR, Tween.EASE_IN),
			StepValue.new(StepValue.Mode.FIXED))
	
	_rot_seq.insert(_rot_seq.size()-1, step)


func remove_rotation_step(index: int) -> void:
	if index <= 0 and index >= _rot_seq.size()-1:
		return
	
	_rot_seq.remove(index)


func shift_rotation_step_left(index: int) -> void:
	if index <= 0 and index >= _rot_seq.size()-1:
		return
	
	Utils.shift_elt_left(_rot_seq, index)


func shift_rotation_step_right(index: int) -> void:
	if index <= 0 and index >= _rot_seq.size()-1:
		return
	
	Utils.shift_elt_right(_rot_seq, index)


func setup_for(tween: Tween, node: Node2D) -> void:
	_setup_pos(tween, node)
	_setup_scale(tween, node)
	_setup_rotation(tween, node)


func _setup_pos(tween: Tween, node: Node2D) -> void:
	var prev_val: Vector2 = node.position
	var delay: float = 0.0
	
	for step in _pos_seq:
		if step.transi != null:
			var final_pos = node.position + step.val.vec_val
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_pos = node.position
				StepValue.Mode.RANDOM:
					final_pos = node.position + _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			tween.interpolate_property(
				node, "position",
				prev_val, final_pos,
				step.transi.duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_pos
			delay += step.transi.duration


func _setup_scale(tween: Tween, node: Node2D) -> void:
	var prev_val: Vector2 = node.scale
	var delay: float = 0.0
	
	for step in _scale_seq:
		if step.transi != null:
			var final_scale = node.scale * step.val.vec_val
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_scale = node.scale
				StepValue.Mode.RANDOM:
					final_scale = node.scale * _rng.random_vec2_range(
						step.val.vec_val, step.val.vec_range)
			
			tween.interpolate_property(
				node, "scale",
				prev_val, final_scale,
				step.transi.duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_scale
			delay += step.transi.duration


func _setup_rotation(tween: Tween, node: Node2D) -> void:
	var prev_val: float = node.rotation_degrees
	var delay: float = 0.0
	
	for step in _rot_seq:
		if step.transi != null:
			var final_rot = node.rotation_degrees + step.val.num_val
			match step.val.mode:
				StepValue.Mode.INITIAL:
					final_rot = node.rotation_degrees
				StepValue.Mode.RANDOM:
					final_rot = node.rotation_degrees + _rng.randomf_range(
						step.val.num_val, step.val.num_range)
			
			tween.interpolate_property(
				node, "rotation_degrees",
				prev_val, final_rot,
				step.transi.duration, step.transi.type, step.transi.easing, delay)
			
			prev_val = final_rot
			delay += step.transi.duration

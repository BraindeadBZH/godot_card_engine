tool
class_name AnimationManager
extends AbstractManager

signal changed()

const FORMAT_ANIM_PATH = "%s/%s.data"

var _folder: String = ""
var _animations: Dictionary = {}

func clean() -> void:
	_animations = {}


func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []
	
	if form_name == "new_animation":
		var id = form["id"]
		if id.empty():
			errors.append("Animation ID cannot be empty")
		elif !form["edit"] and _animations.has(id):
			errors.append("Animation ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid animation ID, must only contains alphanumeric characters or _, no space and starts with a letter")
	
	elif form_name == "delete_animation":
		if !form["confirm"]:
			errors.append("Please confirm first")
	
	return errors


func load_animations(node_folder: String, anim_folder: String) -> void:
	_folder = anim_folder
	
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if Utils.is_anim_file(filename):
				var anim = _read_animation(_folder + filename)
				_animations[anim.id] = anim
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine animation folder")


func animations() -> Dictionary:
	return _animations;


func create_animation(anim: AnimationData) -> void:
	_animations[anim.id] = anim
	_write_animation(anim)
	emit_signal("changed")


func get_animation(id: String) -> AnimationData:
	if _animations.has(id):
		return _animations[id]
	else:
		return null


func update_animation(modified_anim: AnimationData) -> void:
	_animations[modified_anim.id] = modified_anim
	_write_animation(modified_anim)
	emit_signal("changed")


func delete_animation(id: String):
	if !_animations.has(id): return
	
	var anim = _animations[id]
	_animations.erase(id)
	
	var dir = Directory.new()
	dir.remove(FORMAT_ANIM_PATH % [_folder, anim.id])
	
	emit_signal("changed")


func reset_animation(anim: AnimationData) -> AnimationData:
	var new_anim = _read_animation(FORMAT_ANIM_PATH % [_folder, anim.id])
	
	_animations[anim.id] = new_anim
	
	return new_anim


func _write_animation(anim: AnimationData):
	var file = ConfigFile.new()
	
	file.set_value("meta", "id", anim.id)
	file.set_value("meta", "name", anim.name)
	
	file.set_value("seq", "pos", _from_sequence(anim.position_seq()))
	file.set_value("seq", "scale", _from_sequence(anim.scale_seq()))
	file.set_value("seq", "rot", _from_sequence(anim.rotation_seq()))
	
	var err = file.save(FORMAT_ANIM_PATH % [_folder, anim.id])
	if err != OK:
		printerr("Error while writing animation")
		return


func _read_animation(filename: String) -> AnimationData:
	var file = ConfigFile.new()
	
	var err = file.load(filename)
	if err != OK:
		printerr("Error while loading animation")
		return null
	
	var anim = AnimationData.new(file.get_value("meta", "id", ""),
			file.get_value("meta", "name", ""))
	
	anim.set_position_seq(_to_sequence(file.get_value("seq", "pos", [])))
	anim.set_scale_seq(_to_sequence(file.get_value("seq", "scale", [])))
	anim.set_rotation_seq(_to_sequence(file.get_value("seq", "rot", [])))
	
	return anim


func _from_sequence(seq: Array) -> Array:
	var data := []
	for step in seq:
		var step_data := {}
		step_data["editable_transi"] = step.editable_transi
		step_data["editable_val"] = step.editable_val
		
		if step.transi != null:
			step_data["transi"] = {}
			step_data["transi"]["duration"] = step.transi.duration
			step_data["transi"]["type"] = _from_transi_type(step.transi.type)
			step_data["transi"]["easing"] = _from_transi_easing(step.transi.easing)
			
		if step.val != null:
			step_data["val"] = {}
			step_data["val"]["mode"] = _from_val_mode(step.val.mode)
			step_data["val"]["vec_val"] = step.val.vec_val
			step_data["val"]["num_val"] = step.val.num_val
			step_data["val"]["vec_range"] = step.val.vec_range
			step_data["val"]["num_range"] = step.val.num_range
			
		data.append(step_data)
	
	return data


func _to_sequence(data: Array) -> Array:
	var seq := []
	
	for step_data in data:
		var transi: StepTransition = null
		var val: StepValue = null
		
		if step_data.has("transi"):
			transi = StepTransition.new(
				step_data["transi"]["duration"],
				_to_transi_type(step_data["transi"]["type"]),
				_to_transi_easing(step_data["transi"]["easing"]))
		
		if step_data.has("val"):
			val = StepValue.new(_to_val_mode(step_data["val"]["mode"]))
			val.vec_val = step_data["val"]["vec_val"]
			val.num_val = step_data["val"]["num_val"]
			val.vec_range = step_data["val"]["vec_range"]
			val.num_range = step_data["val"]["num_range"]
			
		var step = AnimationStep.new(
			transi, val,
			step_data["editable_transi"],
			step_data["editable_val"])
		seq.append(step)
		
	return seq


func _from_transi_type(type: int) -> String:
	match type:
		Tween.TRANS_LINEAR:
			return "linear"
		Tween.TRANS_SINE:
			return "sine"
		Tween.TRANS_QUINT:
			return "quint"
		Tween.TRANS_QUART:
			return "quart"
		Tween.TRANS_QUAD:
			return "quad"
		Tween.TRANS_EXPO:
			return "expo"
		Tween.TRANS_ELASTIC:
			return "elastic"
		Tween.TRANS_CUBIC:
			return "cubic"
		Tween.TRANS_CIRC:
			return "circ"
		Tween.TRANS_BOUNCE:
			return "bounce"
		Tween.TRANS_BACK:
			return "back"
		_:
			return "linear"


func _to_transi_type(type: String) -> int:
	match type:
		"linear":
			return Tween.TRANS_LINEAR
		"sine":
			return Tween.TRANS_SINE
		"quint":
			return Tween.TRANS_QUINT
		"quart":
			return Tween.TRANS_QUART
		"quad":
			return Tween.TRANS_QUAD
		"expo":
			return Tween.TRANS_EXPO
		"elastic":
			return Tween.TRANS_ELASTIC
		"cubic":
			return Tween.TRANS_CUBIC
		"circ":
			return Tween.TRANS_CIRC
		"bounce":
			return Tween.TRANS_BOUNCE
		"back":
			return Tween.TRANS_BACK
		_:
			return Tween.TRANS_LINEAR


func _from_transi_easing(easing: int) -> String:
	match easing:
		Tween.EASE_IN:
			return "in"
		Tween.EASE_OUT:
			return "out"
		Tween.EASE_IN_OUT:
			return "in_out"
		Tween.EASE_OUT_IN:
			return "out_in"
		_:
			return "in"


func _to_transi_easing(easing: String) -> int:
	match easing:
		"in":
			return Tween.EASE_IN
		"out":
			return Tween.EASE_OUT
		"in_out":
			return Tween.EASE_IN_OUT
		"out_in":
			return Tween.EASE_OUT_IN
		_:
			return Tween.EASE_IN


func _from_val_mode(mode: int) -> String:
	match mode:
		StepValue.Mode.INITIAL:
			return "initial"
		StepValue.Mode.FIXED:
			return "fixed"
		StepValue.Mode.RANDOM:
			return "random"
		_:
			return "initial"


func _to_val_mode(mode: String) -> int:
	match mode:
		"initial":
			return StepValue.Mode.INITIAL
		"fixed":
			return StepValue.Mode.FIXED
		"random":
			return StepValue.Mode.RANDOM
		_:
			return StepValue.Mode.INITIAL


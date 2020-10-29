tool
class_name AnimationManager
extends AbstractManager

signal changed()

const FORMAT_ANIM_PATH = "%s/%s.anim"

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


func load_animations(folder: String) -> void:
	_folder = folder
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if Utils.is_anim_file(filename):
				var anim = _read_animation(filename)
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


func _write_animation(anim: AnimationData):
	var file = ConfigFile.new()
	
	file.set_value("meta", "id", anim.id)
	file.set_value("meta", "name", anim.name)
	
	# TODO
	
	var err = file.save(FORMAT_ANIM_PATH % [_folder, anim.id])
	if err != OK:
		printerr("Error while writing animation")
		return


func _read_animation(filename: String) -> AnimationData:
	var path = _folder + filename
	var file = ConfigFile.new()
	
	var err = file.load(path)
	if err != OK:
		printerr("Error while loading animation")
		return null
	
	var anim = AnimationData.new(file.get_value("meta", "id", ""),
			file.get_value("meta", "name", ""))

	# TODO
	
	return anim


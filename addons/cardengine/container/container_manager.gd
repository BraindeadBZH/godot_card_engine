tool
extends AbstractManager
class_name ContainerManager

var _folder: String = ""
var _containers: Dictionary = {}

func clean():
	_containers = {}

func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []
	
	# TODO
	
	return errors

func load_containers(folder: String) -> void:
	_folder = folder
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			pass # TODO
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine container folder")

func containers() -> Dictionary:
	return _containers

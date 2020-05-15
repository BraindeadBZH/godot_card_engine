tool
extends AbstractManager
class_name ContainerManager

signal changed()

const FMT_PRIVATE_FOLDER = "%s/%s"
const FMT_PRIVATE_DATA   = "%s/%s/%s.data"
const FMT_PRIVATE_SCENE  = "%s/%s/%s.tscn"
const FMT_PRIVATE_SCRIPT = "%s/%s/%s.gd"
const FMT_PRIVATE_TPL    = "%s/container_private.gd.tpl"

var _folder: String = ""
var _tpl_folder: String = ""
var _containers: Dictionary = {}

func clean():
	_containers = {}

func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []
	
	if form_name == "new_container":
		var id = form["id"]
		if id.empty():
			errors.append("Container ID cannot be empty")
		elif !form["edit"] && _containers.has(id):
			errors.append("Container ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid container ID, must only contains alphanumeric characters or _, no space and starts with a letter")
	
	return errors

func load_containers(folder: String, tpl_folder: String) -> void:
	_folder = folder
	_tpl_folder = tpl_folder
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				var cont = _read_metadata(filename)
				_containers[cont.id] = cont
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine container folder")

func containers() -> Dictionary:
	return _containers

func create_container(cont: ContainerData) -> void:
	_containers[cont.id] = cont
	
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.make_dir(cont.id)
		_write_metadata(cont)
		_write_scene(cont)
	else:
		printerr("Could not access CardEngine container folder")
		return
	
	emit_signal("changed")

func get_container(id: String) -> ContainerData:
	if !_containers.has(id): return null
	return _containers[id]

func update_container(modified_cont: ContainerData) -> void:
	_containers[modified_cont.id] = modified_cont
	_write_metadata(modified_cont)
	_write_scene(modified_cont)
	emit_signal("changed")

func delete_container(cont: ContainerData) -> void:
	if Utils.directory_remove_recursive(FMT_PRIVATE_FOLDER % [_folder, cont.id]):
		_containers.erase(cont.id)
		emit_signal("changed")
	else:
		printerr("Container not accessible")

func _write_metadata(cont: ContainerData) -> void:
	var file = ConfigFile.new()
	file.set_value("meta", "id"  , cont.id  )
	file.set_value("meta", "name", cont.name)
	file.save(FMT_PRIVATE_DATA % [_folder, cont.id, cont.id])

func _write_scene(cont: ContainerData) -> void:
	var tpl_path = FMT_PRIVATE_TPL % _tpl_folder
	var script_path = FMT_PRIVATE_SCRIPT % [_folder, cont.id, cont.id]
	Utils.copy_template(
		tpl_path, script_path, 
		{
			"container_id": cont.id,
			"container_name": cont.name
		})
		
	var root = AbstractContainer.new()
	root.name = cont.id
	root.set_script(load(script_path))
	var scene = PackedScene.new()
	var result = scene.pack(root)
	if result == OK:
		result = ResourceSaver.save(
			FMT_PRIVATE_SCENE % [_folder, cont.id, cont.id], scene)
		if result != OK:
			printerr("Cannot save container scene")

func _read_metadata(id: String) -> ContainerData:
	var file = ConfigFile.new()
	
	var err = file.load(FMT_PRIVATE_DATA % [_folder, id, id])
	if err != OK:
		printerr("Error while loading container")
		return null
		
	return ContainerData.new(file.get_value("meta", "id"  , ""),
							 file.get_value("meta", "name", ""))

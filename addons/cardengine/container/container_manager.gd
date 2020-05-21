tool
class_name ContainerManager
extends AbstractManager

signal changed()

const FMT_PRIVATE_FOLDER = "%s/%s"
const FMT_PRIVATE_DATA = "%s/%s/%s.data"
const FMT_PRIVATE_SCENE = "%s/%s/%s.tscn"
const FMT_PRIVATE_SCRIPT = "%s/%s/%s.gd"
const FMT_PRIVATE_TPL = "%s/container_private.gd.tpl"

const FMT_IMPL_FOLDER = "%s/%s"
const FMT_IMPL_SCENE = "%s/%s/%s.tscn"
const FMT_IMPL_SCRIPT = "%s/%s/%s.gd"
const FMT_IMPL_TPL = "%s/container.gd.tpl"

var _folder: String = ""
var _private_folder: String = ""
var _tpl_folder: String = ""
var _containers: Dictionary = {}


func clean() -> void:
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


func load_containers(folder: String, private_folder: String, tpl_folder: String) -> void:
	_folder = folder
	_private_folder = private_folder
	_tpl_folder = tpl_folder
	var dir = Directory.new()
	if dir.open(_private_folder) == OK:
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
	if dir.open(_private_folder) == OK:
		dir.make_dir(cont.id)
		var private_scene = _write_private_scene(cont)
		if private_scene == null:
			return
		_write_public_scene(cont, private_scene)
		_write_metadata(cont)
	else:
		printerr("Could not access CardEngine container folder")
		return
	
	emit_signal("changed")


func get_container(id: String) -> ContainerData:
	if !_containers.has(id):
		return null
	return _containers[id]


func update_container(modified_cont: ContainerData) -> void:
	_containers[modified_cont.id] = modified_cont
	_write_private_scene(modified_cont)
	_write_metadata(modified_cont)
	emit_signal("changed")


func delete_container(cont: ContainerData) -> void:
	if Utils.directory_remove_recursive(FMT_PRIVATE_FOLDER % [_private_folder, cont.id]):
		_containers.erase(cont.id)
		emit_signal("changed")
	else:
		printerr("Container not accessible")


func _write_metadata(cont: ContainerData) -> void:
	var file = ConfigFile.new()
	file.set_value("meta", "id"  , cont.id  )
	file.set_value("meta", "name", cont.name)
	file.save(FMT_PRIVATE_DATA % [_private_folder, cont.id, cont.id])


func _write_private_scene(cont: ContainerData) -> PackedScene:
	var dir = Directory.new()
	if !dir.dir_exists(FMT_PRIVATE_FOLDER % [_private_folder, cont.id]):
		dir.make_dir_recursive(FMT_PRIVATE_FOLDER % [_private_folder, cont.id])
	
	var tpl_path = FMT_PRIVATE_TPL % _tpl_folder
	var script_path = FMT_PRIVATE_SCRIPT % [_private_folder, cont.id, cont.id]
	Utils.copy_template(
		tpl_path, script_path, 
		{
			"container_id": cont.id,
			"container_name": cont.name
		})
		
	var root = AbstractContainer.new()
	root.name = "%s_private" % cont.id
	root.set_script(load(script_path))
	var scene = PackedScene.new()
	var result = scene.pack(root)
	if result == OK:
		result = ResourceSaver.save(
			FMT_PRIVATE_SCENE % [_private_folder, cont.id, cont.id], scene)
		if result != OK:
			printerr("Cannot save private container scene")
			return null
	
	return scene


func _write_public_scene(cont: ContainerData, private_scene: PackedScene) -> void:
	var dir = Directory.new()
	if dir.dir_exists(FMT_IMPL_FOLDER % [_folder, cont.id]):
		return
	else:
		dir.make_dir_recursive(FMT_IMPL_FOLDER % [_folder, cont.id])
	
	var tpl_path = FMT_IMPL_TPL % _tpl_folder
	var script_path = FMT_IMPL_SCRIPT % [_folder, cont.id, cont.id]
	Utils.copy_template(
		tpl_path, script_path, 
		{
			"container_id": cont.id,
			"container_name": cont.name,
			"private_script": FMT_PRIVATE_SCRIPT % [_private_folder, cont.id, cont.id]
		})
		
	var root = private_scene.instance()
	root.name = cont.id
	root.set_script(load(script_path))
	var scene = PackedScene.new()
	var result = scene.pack(root)
	if result == OK:
		result = ResourceSaver.save(
			FMT_IMPL_SCENE % [_folder, cont.id, cont.id], scene)
		if result != OK:
			printerr("Cannot save container scene")


func _read_metadata(id: String) -> ContainerData:
	var file = ConfigFile.new()
	
	var err = file.load(FMT_PRIVATE_DATA % [_private_folder, id, id])
	if err != OK:
		printerr("Error while loading container")
		return null
		
	return ContainerData.new(file.get_value("meta", "id"  , ""),
							 file.get_value("meta", "name", ""))

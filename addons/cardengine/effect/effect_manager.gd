tool
class_name EffectManager
extends AbstractManager

signal changed()

const FORMAT_FX_DB = "%s/effects.data"
const FORMAT_FX_TPL = "%s/effect.tpl"
const FORMAT_FX_SCRIPT = "%s/%s.gd"

var _folder: String = ""
var _db_path: String = ""
var _tpl_path: String = ""
var _effects: Dictionary = {}


func clean() -> void:
	_effects.clear()


func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []

	if form_name == "new_effect":
		var id = form["id"]
		if id.empty():
			errors.append("Effect ID cannot be empty")
		elif !form["edit"] && _effects.has(id):
			errors.append("Effect ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid effect ID, must only contains alphanumeric characters or _, no space and starts with a letter")

		var name = form["name"]
		if name.empty():
			errors.append("Effect Name cannot be empty")

	return errors


func load_effects(folder: String, private_folder: String, tpl_folder: String) -> void:
	_folder = folder
	_db_path = FORMAT_FX_DB % private_folder
	_tpl_path = FORMAT_FX_TPL % tpl_folder

	_read_metadata()

	emit_signal("changed")


func effects() -> Dictionary:
	return _effects


func create_effect(id: String, name: String) -> void:
	var script_path := FORMAT_FX_SCRIPT % [_folder, id]

	if not Utils.copy_template(_tpl_path, script_path, {}):
		printerr("Failed to create effect")
		return

	CardEngine.scan_for_new_files()
	_load_effect(id, name)
	_write_metadata()

	emit_signal("changed")


func get_effect(id: String) -> AbstractEffect:
	if not _effects.has(id):
		return null
	return _effects[id]


func update_effect(id: String, new_name: String) -> void:
	if not _effects.has(id):
		return

	_effects[id].name = new_name
	_write_metadata()

	emit_signal("changed")


func delete_effect(id: String) -> void:
	if !_effects.has(id):
		return

	_effects.erase(id)

	var dir = Directory.new()
	dir.remove(FORMAT_FX_SCRIPT % [_folder, id])

	CardEngine.scan_for_new_files()
	_write_metadata()

	emit_signal("changed")


func instantiate(id: String) -> EffectInstance:
	if _effects.has(id):
		return EffectInstance.new(_effects[id])
	else:
		return null


func edit(id: String) -> void:
	var script := load(FORMAT_FX_SCRIPT % [_folder, id])
	CardEngine.open_for_edit(script)


func _read_metadata() -> void:
	var file := ConfigFile.new()

	var err = file.load(_db_path)
	if err != OK:
		printerr("Error while loading effects")
		return

	for id in file.get_section_keys("effects"):
		if id == "count":
			continue

		var name = file.get_value("effects", id, "")
		_load_effect(id, name)


func _write_metadata() -> void:
	var file := ConfigFile.new()

	file.set_value("effects", "count", _effects.size())

	for id in _effects:
		var fx: AbstractEffect = _effects[id]
		file.set_value("effects", id, fx.name)

	file.save(_db_path)


func _load_effect(id: String, name: String) -> void:
	var fx: GDScript = load(FORMAT_FX_SCRIPT % [_folder, id])
	_effects[id] = fx.new(id, name)

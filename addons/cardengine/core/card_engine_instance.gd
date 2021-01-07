tool
class_name CardEngineInstance
extends Node

const CONF_FILE_PATH = "res://project.cardengine"

var _plugin: EditorPlugin = null
var _conf: ConfigFile = ConfigFile.new()
var _general: GeneralManager = GeneralManager.new()
var _databases: DatabaseManager = DatabaseManager.new()
var _containers: ContainerManager = ContainerManager.new()
var _animations: AnimationManager = AnimationManager.new()
var _effects: EffectManager = EffectManager.new()


func setup(plugin: EditorPlugin = null) -> void:
	_plugin = plugin

	if _conf.load(CONF_FILE_PATH) != OK:
		printerr("Could not load CardEngine config file")
	else:
		_databases.load_databases(_conf.get_value("folders", "databases"))

		_containers.load_containers(
			_conf.get_value("folders", "containers"),
				_conf.get_value("folders", "containers_private"),
				_conf.get_value("folders", "container_tpl"))

		_animations.load_animations(_conf.get_value("folders", "animations"))

		_effects.load_effects(
			_conf.get_value("folders", "effects"),
			_conf.get_value("folders", "effects_private"),
			_conf.get_value("folders", "effects_tpl"))


func clean() -> void:
	_general.clean()
	_databases.clean()
	_containers.clean()
	_animations.clean()
	_effects.clean()


func general() -> GeneralManager:
	return _general


func db() -> DatabaseManager:
	return _databases


func cont() -> ContainerManager:
	return _containers


func anim() -> AnimationManager:
	return _animations


func fx() -> EffectManager:
	return _effects


func scan_for_new_files() -> void:
	if _plugin != null:
		_plugin.get_editor_interface().get_resource_filesystem().scan()


func open_for_edit(res: Resource) -> void:
	_plugin.get_editor_interface().edit_resource(res)


func open_scene(path: String) -> void:
	_plugin.get_editor_interface().open_scene_from_path(path)

tool
extends Node
class_name CardEngineInstance

const CONF_FILE_PATH = "res://project.cardengine"

var _conf: ConfigFile = ConfigFile.new()
var _databases: DatabaseManager = DatabaseManager.new()

func setup():
	if _conf.load(CONF_FILE_PATH) != OK:
		printerr("Could not load CardEngine config file")
	else:
		_databases.load_databases(_conf.get_value("folders", "databases"))

func clean():
	_databases.clean()

func db() -> DatabaseManager:
	return _databases

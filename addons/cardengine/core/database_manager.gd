tool
extends AbstractManager
class_name DatabaseManager

signal changed()

var _folder = ""
var _databases = {}

func clean():
	_databases = {}

func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []
	if form_name == "new_database":
		var id = form["id"]
		if id.empty():
			errors.append("Database ID cannot be empty")
		elif _databases.has(id):
			errors.append("Database ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid database ID, must only contains alphanumeric characters or _, no space and starts with a letter")
	return errors

func create_database(id: String, name: String):
	var db = CardDatabase.new(id, name, _folder + id + ".data")
	_databases[id] = db
	
	write_database(db)
	
	emit_signal("changed")

func get_databases() -> Dictionary:
	return _databases;

func write_database(db: CardDatabase):
	var file = ConfigFile.new()
	
	file.set_value("meta", "id"  , db.id)
	file.set_value("meta", "name", db.name)
	file.set_value("meta", "path", db.path)
	
	var err = file.save(db.path)
	if err != OK:
		printerr("Error while writing database")
		return

func read_database(filename: String) -> CardDatabase:
	var path = _folder + filename
	var file = ConfigFile.new()
	
	var err = file.load(path)
	if err != OK:
		printerr("Error while loading database")
		return null
	
	var db = CardDatabase.new(file.get_value("meta", "id"  ),
							  file.get_value("meta", "name"),
							  file.get_value("meta", "path"))
	
	return db

func load_databases(folder: String):
	_folder = folder
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if Utils.is_db_file(filename):
				var db = read_database(filename)
				_databases[db.id] = db
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine database folder")

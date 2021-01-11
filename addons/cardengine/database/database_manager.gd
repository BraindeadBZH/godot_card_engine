tool
class_name DatabaseManager
extends AbstractManager

signal changed()

const FORMAT_DB_PATH = "%s/%s.data"

var _folder: String = ""
var _databases: Dictionary = {}

func clean() -> void:
	_databases = {}


func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []

	if form_name == "new_database":
		var id = form["id"]
		if id.empty():
			errors.append("Database ID cannot be empty")
		elif !form["edit"] && _databases.has(id):
			errors.append("Database ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid database ID, must only contains alphanumeric characters or _, no space and starts with a letter")

	elif form_name == "delete_database":
		if !form["confirm"]:
			errors.append("Please confirm first")

	elif form_name == "category":
		if !Utils.is_id_valid(form["meta_categ"]):
			errors.append("Invalid meta-category")

		if !Utils.is_id_valid(form["categ"]):
			errors.append("Invalid category")

	elif form_name == "value":
		if !Utils.is_id_valid(form["id"]):
			errors.append("Invalid value ID")

	elif form_name == "text":
		if !Utils.is_id_valid(form["id"]):
			errors.append("Invalid text ID")

	elif form_name == "duplicate_card":
		var id = form["id"]
		if id.empty():
			errors.append("Card ID cannot be empty")
		elif get_database(form["db"]).card_exists(id):
			errors.append("Card already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid card ID, must only contains alphanumeric characters or _, no space and starts with a letter")

	return errors


func load_databases(folder: String) -> void:
	_folder = folder
	var dir = Directory.new()
	if dir.open(_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if Utils.is_db_file(filename):
				var db = _read_database(filename)
				_databases[db.id] = db
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine database folder")


func databases() -> Dictionary:
	return _databases;


func create_database(db: CardDatabase) -> void:
	_databases[db.id] = db
	_write_database(db)
	emit_signal("changed")


func get_database(id: String) -> CardDatabase:
	if _databases.has(id):
		return _databases[id]
	else:
		return null


func update_database(modified_db: CardDatabase) -> void:
	_databases[modified_db.id] = modified_db
	_write_database(modified_db)
	emit_signal("changed")


func delete_database(id: String):
	if !_databases.has(id): return

	var db = _databases[id]
	_databases.erase(id)

	var dir = Directory.new()
	dir.remove(FORMAT_DB_PATH % [_folder, db.id])

	emit_signal("changed")


func _write_database(db: CardDatabase):
	var file = ConfigFile.new()

	file.set_value("meta", "id", db.id)
	file.set_value("meta", "name", db.name)

	for id in db.cards():
		var card = db.get_card(id)
		file.set_value("cards", card.id, {
			"categories": card.categories(),
			"values": card.values(),
			"texts": card.texts()
			})

	var err = file.save(FORMAT_DB_PATH % [_folder, db.id])
	if err != OK:
		printerr("Error while writing database")
		return


func _read_database(filename: String) -> CardDatabase:
	var path = _folder + filename
	var file = ConfigFile.new()

	var err = file.load(path)
	if err != OK:
		printerr("Error while loading database")
		return null

	var db = CardDatabase.new(file.get_value("meta", "id", ""),
			file.get_value("meta", "name", ""))

	if file.has_section("cards"):
		for entry in file.get_section_keys("cards"):
			var card = CardData.new(entry, db.id)
			var data = file.get_value("cards", entry)
			card.set_categories(data["categories"])
			card.set_values(data["values"])
			card.set_texts(data["texts"])
			db.add_card(card)

	return db


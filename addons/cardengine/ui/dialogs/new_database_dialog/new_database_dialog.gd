tool
extends AbstractFormDialog

onready var _db_id = $MainLayout/Form/DatabaseId
onready var _db_name = $MainLayout/Form/DatabaseName


func _ready():
	setup("new_database", CardEngine.db())


func _reset_form():
	_db_id.editable = true
	_db_id.text = ""
	_db_name.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _db_id.text,
		"name": _db_name.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_db_id.editable = false
	_db_id.text = data["id"]
	_db_name.text = data["name"]

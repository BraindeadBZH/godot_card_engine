tool
extends AbstractFormDialog

onready var _categ_id = $MainLayout/Form/CategId
onready var _categ_name = $MainLayout/Form/CategName


func _ready():
	setup("category", CardEngine.db())


func _reset_form() -> void:
	_categ_id.text = ""
	_categ_name.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _categ_id.text,
		"name": _categ_name.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_categ_id.text = data["id"]
	_categ_name.text = data["name"]

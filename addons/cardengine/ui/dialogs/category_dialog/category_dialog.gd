tool
extends AbstractFormDialog

onready var _meta_categ = $MainLayout/Form/MetaCateg
onready var _categ = $MainLayout/Form/Categ


func _ready():
	setup("category", CardEngine.db())


func _reset_form() -> void:
	_meta_categ.text = ""
	_categ.text = ""


func _extract_form() -> Dictionary:
	return {
		"meta_categ": _meta_categ.text,
		"categ": _categ.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_meta_categ.text = data["meta_categ"]
	_categ.text = data["categ"]

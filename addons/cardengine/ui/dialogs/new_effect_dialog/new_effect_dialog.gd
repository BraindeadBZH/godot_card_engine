tool
extends AbstractFormDialog

onready var _fx_id = $MainLayout/Form/FxId
onready var _fx_name = $MainLayout/Form/FxName


func _ready():
	setup("new_effect", CardEngine.fx())


func _reset_form():
	_fx_id.editable = true
	_fx_id.text = ""
	_fx_name.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _fx_id.text,
		"name": _fx_name.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_fx_id.editable = false
	_fx_id.text = data["id"]
	_fx_name.text = data["name"]

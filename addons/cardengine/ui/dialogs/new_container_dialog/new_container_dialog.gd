tool
extends AbstractFormDialog

onready var _cont_id = $MainLayout/Form/ContainerId
onready var _cont_name = $MainLayout/Form/ContainerName


func _ready():
	setup("new_container", CardEngine.cont())


func _reset_form() -> void:
	_cont_id.editable = true
	_cont_id.text = ""
	_cont_name.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _cont_id.text,
		"name": _cont_name.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_cont_id.editable = false
	_cont_id.text = data["id"]
	_cont_name.text = data["name"]


tool
extends AbstractFormDialog

onready var _anim_id = $MainLayout/Form/AnimationId
onready var _anim_name = $MainLayout/Form/AnimationName


func _ready():
	setup("new_animation", CardEngine.anim())


func _reset_form():
	_anim_id.editable = true
	_anim_id.text = ""
	_anim_name.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _anim_id.text,
		"name": _anim_name.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_anim_id.editable = false
	_anim_id.text = data["id"]
	_anim_name.text = data["name"]

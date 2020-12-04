tool
extends AbstractFormDialog

onready var _text_id = $MainLayout/Form/TextId
onready var _text = $MainLayout/Form/Text


func _ready():
	setup("text", CardEngine.db())


func _reset_form() -> void:
	_text_id.text = ""
	_text.text = ""


func _extract_form() -> Dictionary:
	return {
		"id": _text_id.text,
		"text": _text.text,
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_text_id.text = data["id"]
	_text.text = data["text"]

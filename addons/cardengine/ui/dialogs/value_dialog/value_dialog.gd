tool
extends AbstractFormDialog

onready var _value_id = $MainLayout/Form/ValueId
onready var _value = $MainLayout/Form/ValueVal


func _ready():
	setup("value", CardEngine.db())


func _reset_form() -> void:
	_value_id.text = ""
	_value.value = 0


func _extract_form() -> Dictionary:
	return {
		"id": _value_id.text,
		"value": int(_value.value),
		"edit": is_edit()
	}


func _fill_form(data: Dictionary) -> void:
	_value_id.text = data["id"]
	_value.value = data["value"]

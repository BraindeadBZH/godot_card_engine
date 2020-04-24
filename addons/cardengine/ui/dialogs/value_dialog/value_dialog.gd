tool
extends AbstractFormDialog

func _ready():
	setup("value", CardEngine.db())

func _reset_form():
	$MainLayout/Form/ValueId.text = ""
	$MainLayout/Form/ValueVal.value = 0.0

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/ValueId.text,
		"value": $MainLayout/Form/ValueVal.value,
		"edit": is_edit()
	}

func _fill_form(data: Dictionary):
	$MainLayout/Form/ValueId.text = data["id"]
	$MainLayout/Form/ValueVal.value = data["value"]

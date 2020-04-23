tool
extends "../abstract_form_dialog/abstract_form_dialog.gd"

func _ready():
	setup("value", CardEngine.db())

func _reset_form():
	$MainLayout/Form/ValueId.text = ""
	$MainLayout/Form/ValueVal.value = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/ValueId.text,
		"value": $MainLayout/Form/ValueVal.value
	}

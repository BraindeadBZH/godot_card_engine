tool
extends "../abstract_form_dialog/abstract_form_dialog.gd"

func _ready():
	setup("category", CardEngine.db())

func _reset_form():
	$MainLayout/Form/CategId.text = ""
	$MainLayout/Form/CategName.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/CategId.text,
		"name": $MainLayout/Form/CategName.text
	}

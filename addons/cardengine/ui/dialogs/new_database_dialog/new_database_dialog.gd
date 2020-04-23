tool
extends "../abstract_form_dialog/abstract_form_dialog.gd"

func _ready():
	setup("new_database", CardEngine.db())

func _reset_form():
	$MainLayout/Form/DatabaseId.text = ""
	$MainLayout/Form/DatabaseName.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/DatabaseId.text,
		"name": $MainLayout/Form/DatabaseName.text
	}

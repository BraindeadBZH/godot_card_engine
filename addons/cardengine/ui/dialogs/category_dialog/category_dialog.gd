tool
extends AbstractFormDialog

func _ready():
	setup("category", CardEngine.db())

func _reset_form():
	$MainLayout/Form/CategId.text = ""
	$MainLayout/Form/CategName.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/CategId.text,
		"name": $MainLayout/Form/CategName.text,
		"edit": is_edit()
	}

func _fill_form(data: Dictionary):
	$MainLayout/Form/CategId.text = data["id"]
	$MainLayout/Form/CategName.text = data["name"]

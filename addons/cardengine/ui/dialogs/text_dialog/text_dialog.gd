tool
extends AbstractFormDialog

func _ready():
	setup("category", CardEngine.db())

func _reset_form():
	$MainLayout/Form/TextId.text = ""
	$MainLayout/Form/Text.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/TextId.text,
		"text": $MainLayout/Form/Text.text,
		"edit": is_edit()
	}

func _fill_form(data: Dictionary):
	$MainLayout/Form/TextId.text = data["id"]
	$MainLayout/Form/Text.text = data["text"]

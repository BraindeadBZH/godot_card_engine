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
		"text": $MainLayout/Form/Text.text
	}

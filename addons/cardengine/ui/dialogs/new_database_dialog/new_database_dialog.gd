tool
extends AbstractFormDialog

func _ready():
	setup("new_database", CardEngine.db())

func _reset_form():
	$MainLayout/Form/DatabaseId.editable = true
	$MainLayout/Form/DatabaseId.text = ""
	$MainLayout/Form/DatabaseName.text = ""
	$MainLayout/Form/DatabaseCardLayout/DatabaseCard.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": $MainLayout/Form/DatabaseId.text,
		"name": $MainLayout/Form/DatabaseName.text,
		"visual": $MainLayout/Form/DatabaseCardLayout/DatabaseCard.text,
		"edit": is_edit()
	}

func _fill_form(data: Dictionary):
	$MainLayout/Form/DatabaseId.editable = false
	$MainLayout/Form/DatabaseId.text = data["id"]
	$MainLayout/Form/DatabaseName.text = data["name"]
	$MainLayout/Form/DatabaseCardLayout/DatabaseCard.text = data["visual"]

func _on_DatabaseCardChange_pressed():
	$CardSelect.current_file = $MainLayout/Form/DatabaseCardLayout/DatabaseCard.text
	$CardSelect.popup_centered_minsize(Vector2(400, 250))

func _on_CardSelect_file_selected(path):
	$MainLayout/Form/DatabaseCardLayout/DatabaseCard.text = path

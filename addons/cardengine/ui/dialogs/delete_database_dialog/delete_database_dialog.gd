tool
extends "../abstract_form_dialog/abstract_form_dialog.gd"

signal deletion_confirmed()

func _ready():
	setup("delete_database", CardEngine.db())

func _reset_form():
	$MainLayout/Form/Confirmation.pressed = false

func _extract_form() -> Dictionary:
	return {
		"confirm": $MainLayout/Form/Confirmation.pressed
	}

func _on_DeleteDatabaseDialog_form_validated():
	emit_signal("deletion_confirmed")

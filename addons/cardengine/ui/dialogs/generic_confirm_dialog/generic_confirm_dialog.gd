tool
extends "../abstract_form_dialog/abstract_form_dialog.gd"

func _ready():
	setup("generic_confirm", CardEngine.general())

func _reset_form():
	$MainLayout/Form/Confirmation.pressed = false

func _extract_form() -> Dictionary:
	return {
		"confirm": $MainLayout/Form/Confirmation.pressed
	}

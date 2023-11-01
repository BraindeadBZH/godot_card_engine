@tool
extends AbstractFormDialog

var _confirmed: bool = false

# TODO: replace yield by await
#var _ctx: GDScriptFunctionState = null

@onready var _confirmation = $MainLayout/Form/Confirmation


func _ready():
	setup("generic_confirm", CardEngine.general())


# TODO: replace yield by await
#func ask_confirmation(title: String, ctx: GDScriptFunctionState) -> void:
#	window_title = title
#	_confirmed = false
#	_ctx = ctx
#	popup_centered()


func _reset_form() -> void:
	_confirmation.button_pressed = false


func _extract_form() -> Dictionary:
	return {
		"confirm": _confirmation.button_pressed
	}


func _on_GenericConfirmDialog_form_validated(form) -> void:
	_confirmed = true


# TODO: replace yield by await
#func _on_GenericConfirmDialog_popup_hide() -> void:
#	_ctx.resume(_confirmed)

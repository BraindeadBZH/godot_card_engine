tool
extends AbstractFormDialog

var _confirmed: bool = false
var _ctx: GDScriptFunctionState = null

onready var _confirmation = $MainLayout/Form/Confirmation


func _ready():
	setup("generic_confirm", CardEngine.general())


func ask_confirmation(title: String, ctx: GDScriptFunctionState) -> void:
	window_title = title
	_confirmed = false
	_ctx = ctx
	popup_centered()


func _reset_form() -> void:
	_confirmation.pressed = false


func _extract_form() -> Dictionary:
	return {
		"confirm": _confirmation.pressed
	}


func _on_GenericConfirmDialog_form_validated(form) -> void:
	_confirmed = true


func _on_GenericConfirmDialog_popup_hide() -> void:
	_ctx.resume(_confirmed)

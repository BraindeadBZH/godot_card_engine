tool
extends AbstractFormDialog

var _confirmed: bool = false
var _ctx: GDScriptFunctionState = null

func ask_confirmation(title: String, ctx: GDScriptFunctionState):
	window_title = title
	_confirmed = false
	_ctx = ctx
	popup_centered()

func _ready():
	setup("generic_confirm", CardEngine.general())

func _reset_form():
	$MainLayout/Form/Confirmation.pressed = false

func _extract_form() -> Dictionary:
	return {
		"confirm": $MainLayout/Form/Confirmation.pressed
	}

func _on_GenericConfirmDialog_form_validated(form):
	_confirmed = true

func _on_GenericConfirmDialog_popup_hide():
	_ctx.resume(_confirmed)

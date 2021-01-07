tool
class_name AbstractFormDialog
extends WindowDialog

signal form_validated(form)

var _form_name: String = ""
var _manager: AbstractManager = null
var _edit: bool = false

onready var _error_text = $MainLayout/ErrorText


# Has to be called in the inherited dialog
func setup(form_name: String, manager: AbstractManager) -> void:
	_form_name = form_name
	_manager = manager


func popup_centered(size: Vector2 = Vector2()) -> void:
	_edit = false
	_clear_errors()
	_reset_form()
	.popup_centered(size)


func popup_centered_edit(data: Dictionary) -> void:
	_edit = true
	_clear_errors()
	_fill_form(data)
	.popup_centered()


func is_edit() -> bool:
	return _edit


# To be override
func _reset_form() -> void:
	pass


# To be override
func _extract_form() -> Dictionary:
	return {}


# To be override
func _fill_form(data: Dictionary):
	pass


func _clear_errors() -> void:
	_error_text.hide()
	_error_text.text = ""


func _on_CancelButton_pressed() -> void:
	hide()


func _on_SubmitButton_pressed() -> void:
	_clear_errors()
	var form = _extract_form()
	var errors = _manager.validate_form(_form_name, form)

	if errors.size() == 0:
		emit_signal("form_validated", form)
		hide()
	else:
		for err in errors:
			_error_text.text += "%s\n" % err
		_error_text.show()

tool
extends TabContainer
class_name CardEngineUI

onready var _confirm_dlg = $Dialogs/GenericConfirmDialog
onready var _new_db_dlg = $Dialogs/NewDatabaseDialog
onready var _edit_db_dlg = $Dialogs/EditDatabaseDialog
onready var _categ_dlg = $Dialogs/CategoryDialog
onready var _value_dlg = $Dialogs/ValueDialog
onready var _text_dlg = $Dialogs/TextDialog

var _selected_db = -1

func _ready():
	$Databases.set_main_ui(self)
	$Cards.set_main_ui(self)
	$Containers.set_main_ui(self)

func change_tab(index: int):
	current_tab = index

func show_new_database_dialog(data: Dictionary = {}):
	if data.empty():
		_new_db_dlg.popup_centered()
	else:
		_new_db_dlg.popup_centered_edit(data)

func show_edit_database_dialog(id: String):
	_edit_db_dlg.popup_centered()
	_edit_db_dlg.set_database(id)

func show_confirmation_dialog(title: String, callback: FuncRef, args: Array = []):
	_confirm_dlg.ask_confirmation(title, callback.call_funcv(args))

func show_categ_dialog(data: Dictionary = {}):
	if data.empty():
		_categ_dlg.popup_centered()
	else:
		_categ_dlg.popup_centered_edit(data)

func show_value_dialog(data: Dictionary = {}):
	if data.empty():
		_value_dlg.popup_centered()
	else:
		_value_dlg.popup_centered_edit(data)

func show_text_dialog(data: Dictionary = {}):
	if data.empty():
		_text_dlg.popup_centered()
	else:
		_text_dlg.popup_centered_edit(data)

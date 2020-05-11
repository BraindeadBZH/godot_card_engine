tool
extends Control
class_name DatabasesUi

onready var _db_list = $DatabaseLayout/DatabaseList
onready var _edit_btn = $DatabaseLayout/Toolbar/EditBtn
onready var _delete_btn = $DatabaseLayout/Toolbar/DeleteBtn

var _main_ui: CardEngineUI = null
var _selected_db: int = -1

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui

func delete_database():
	if yield():
		CardEngine.db().delete_database(_db_list.get_item_metadata(_selected_db))

func _on_Databases_changed():
	if _db_list == null: return

	_db_list.clear()
	_edit_btn.disabled = true
	_delete_btn.disabled = true
	
	var databases = CardEngine.db().databases()
	for id in databases:
		var db = databases[id]
		_db_list.add_item("%s: %s" % [db.id, db.name])
		_db_list.set_item_metadata(_db_list.get_item_count()-1, db.id)

func _on_DatabaseList_item_selected(index):
	_selected_db = index
	_edit_btn.disabled = false
	_delete_btn.disabled = false

func _on_DatabaseList_item_activated(index):
	var id = _db_list.get_item_metadata(index)
	_main_ui.show_edit_database_dialog(id)

func _on_CreateBtn_pressed():
	_main_ui.show_new_database_dialog()

func _on_EditBtn_pressed():
	var id = _db_list.get_item_metadata(_selected_db)
	var db = CardEngine.db().get_database(id)
	_main_ui.show_new_database_dialog({"id": db.id, "name": db.name})

func _on_NewDatabaseDialog_form_validated(form):
	if form["edit"]:
		var db = CardEngine.db().get_database(form["id"])
		CardEngine.db().change_database(db, form["name"])
	else:
		CardEngine.db().create_database(form["id"], form["name"])

func _on_DeleteBtn_pressed():
	_main_ui.show_confirmation_dialog("Delete database", funcref(self, "delete_database"))


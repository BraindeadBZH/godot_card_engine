tool
class_name DatabasesUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_db: int = -1

onready var _manager = CardEngine.db()
onready var _db_list = $DatabaseLayout/DatabaseList
onready var _edit_btn = $DatabaseLayout/Toolbar/EditBtn
onready var _delete_btn = $DatabaseLayout/Toolbar/DeleteBtn


func _ready():
	_manager.connect("changed", self, "_on_Databases_changed")


func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui


func delete_database() -> void:
	if yield():
		_manager.delete_database(_db_list.get_item_metadata(_selected_db))


func _on_Databases_changed() -> void:
	if _db_list == null:
		return

	_db_list.clear()
	_edit_btn.disabled = true
	_delete_btn.disabled = true

	var databases = _manager.databases()
	for id in databases:
		var db = databases[id]
		_db_list.add_item("%s: %s (%d cards)" % [db.id, db.name, db.count()])
		_db_list.set_item_metadata(_db_list.get_item_count()-1, db.id)


func _on_DatabaseList_item_selected(index) -> void:
	_selected_db = index
	_edit_btn.disabled = false
	_delete_btn.disabled = false


func _on_DatabaseList_item_activated(index) -> void:
	var db = _manager.get_database(_db_list.get_item_metadata(index))
	_main_ui.show_new_database_dialog({"id": db.id, "name": db.name})


func _on_CreateBtn_pressed() -> void:
	_main_ui.show_new_database_dialog()


func _on_EditBtn_pressed() -> void:
	_main_ui.show_edit_database_dialog(_db_list.get_item_metadata(_selected_db))


func _on_NewDatabaseDialog_form_validated(form) -> void:
	if form["edit"]:
		_manager.update_database(CardDatabase.new(form["id"], form["name"]))
	else:
		_manager.create_database(CardDatabase.new(form["id"], form["name"]))


func _on_DeleteBtn_pressed() -> void:
	_main_ui.show_confirmation_dialog(
			"Delete database", funcref(self, "delete_database"))


func _on_EditDatabaseDialog_copy_card(card_id, new_card_id, db_id) -> void:
	var db = _manager.get_database(db_id)
	if db == null:
		return

	var card = db.get_card(card_id)
	var new_card = card.duplicate()
	new_card.id = new_card_id

	db.add_card(new_card)
	_manager.update_database(db)

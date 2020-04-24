tool
extends Control
class_name CardEngineUI

var _selected_db = -1
var _edited_index = -1
var _edited_data = {}

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

func _database_delete():
	if yield():
		CardEngine.db().delete_database(
			$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _save_card(id: String, db: CardDatabase):
	var card = CardData.new(id)
	for i in range($Card/CardLayout/DataLayout/CategList.get_item_count()):
		var data = $Card/CardLayout/DataLayout/CategList.get_item_metadata(i)
		card.add_category(data["id"], data["name"])
	for i in range($Card/CardLayout/DataLayout/ValuesList.get_item_count()):
		var data = $Card/CardLayout/DataLayout/ValuesList.get_item_metadata(i)
		card.add_value(data["id"], data["value"])
	for i in range($Card/CardLayout/DataLayout/TextsList.get_item_count()):
		var data = $Card/CardLayout/DataLayout/TextsList.get_item_metadata(i)
		card.add_text(data["id"], data["text"])
	db.add_card(card)
	CardEngine.db().write_database(db)

func _overwrite_card(id: String, db: CardDatabase):
	if yield():
		_save_card(id, db)

func _append_category(id: String, name: String):
	var list = $Card/CardLayout/DataLayout/CategList
	list.add_item("%s: %s" % [id, name])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "name": name})

func _replace_category(idx: int, id: String, name: String):
	var list = $Card/CardLayout/DataLayout/CategList
	list.set_item_text(idx, "%s: %s" % [id, name])
	list.set_item_metadata(idx, {"id": id, "name": name})
	
func _append_value(id: String, value: float):
	var list = $Card/CardLayout/DataLayout/ValuesList
	list.add_item("%s = %d" % [id, value])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "value": value})
	
func _replace_value(idx: int, id: String, value: float):
	var list = $Card/CardLayout/DataLayout/ValuesList
	list.set_item_text(idx, "%s = %f" % [id, value])
	list.set_item_metadata(idx, {"id": id, "value": value})

func _append_text(id: String, text: String):
	var list = $Card/CardLayout/DataLayout/TextsList
	list.add_item("%s: %s" % [id, text])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "text": text})

func _replace_text(idx: int, id: String, text: String):
	var list = $Card/CardLayout/DataLayout/TextsList
	list.set_item_text(idx, "%s: %s" % [id, text])
	list.set_item_metadata(idx, {"id": id, "text": text})
	
func _on_CreateBtn_pressed():
	$Dialogs/NewDatabaseDialog.popup_centered()

func _on_Databases_changed():
	var list = $Databases/DatabaseLayout/DatabaseList
	var select = $Card/CardLayout/ToolLayout/DatabaseSelect
	
	list.clear()
	select.clear()
	$Databases/DatabaseLayout/Toolbar/DeleteBtn.disabled = true
	
	var databases = CardEngine.db().databases()
	for id in databases:
		var db = databases[id]
		list.add_item("%s: %s" % [db.id, db.name])
		list.set_item_metadata(list.get_item_count()-1, db.id)
			
		select.add_item("%s: %s" % [db.id, db.name])
		select.set_item_metadata(select.get_item_count()-1, db.id)

func _on_NewDatabaseDialog_form_validated(form):
	CardEngine.db().create_database(form["id"], form["name"])

func _on_DatabaseList_item_selected(index):
	_selected_db = index
	$Databases/DatabaseLayout/Toolbar/DeleteBtn.disabled = false

func _on_DeleteBtn_pressed():
	$Dialogs/GenericConfirmDialog.ask_confirmation("Database Delete", _database_delete())

func _on_DatabaseList_item_activated(index):
	$Dialogs/EditDatabaseDialog.popup_centered()
	$Dialogs/EditDatabaseDialog.set_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_SaveBtn_pressed():
	$Card/CardLayout/ToolLayout/ErrorLbl.text = ""
	
	var id = $Card/CardLayout/ToolLayout/CardId.text
	var db = CardEngine.db().get_database(
		$Card/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())
	
	if db.card_exists(id):
		$Dialogs/GenericConfirmDialog.ask_confirmation("Overwrite Card", _overwrite_card(id, db))
	else:
		_save_card(id, db)

func _on_LoadBtn_pressed():
	$Card/CardLayout/ToolLayout/ErrorLbl.text = ""
	$Card/CardLayout/DataLayout/CategList.clear()
	$Card/CardLayout/DataLayout/ValuesList.clear()
	$Card/CardLayout/DataLayout/TextsList.clear()
	
	var id = $Card/CardLayout/ToolLayout/CardId.text
	var db = CardEngine.db().get_database(
		$Card/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())
	
	var card = db.get_card(id)
	if card == null:
		$Card/CardLayout/ToolLayout/ErrorLbl.text = "Unable to find the card in the database"
	else:
		for categ in card.categories():
			_append_category(categ, card.get_category(categ))
		
		for value in card.values():
			_append_value(value, card.get_value(value))
		
		for text in card.texts():
			_append_text(text, card.get_text(text))
	
func _on_CardId_text_changed(new_text):
	if Utils.is_id_valid(new_text):
		$Card/CardLayout/ToolLayout/SaveBtn.disabled = false
		$Card/CardLayout/ToolLayout/LoadBtn.disabled = false
		$Card/CardLayout/ToolLayout/ErrorLbl.text = ""
	else:
		$Card/CardLayout/ToolLayout/SaveBtn.disabled = true
		$Card/CardLayout/ToolLayout/LoadBtn.disabled = true
		$Card/CardLayout/ToolLayout/ErrorLbl.text = "Invalid ID"

func _on_AddCategBtn_pressed():
	$Dialogs/CategoryDialog.popup_centered()

func _on_CategList_item_activated(index):
	_edited_index = index
	_edited_data = $Card/CardLayout/DataLayout/CategList.get_item_metadata(index)
	$Dialogs/CategoryDialog.popup_centered_edit(_edited_data)

func _on_CategoryDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_category(_edited_index, form["id"], form["name"])
	else:
		_append_category(form["id"], form["name"])

func _on_AddValBtn_pressed():
	$Dialogs/ValueDialog.popup_centered()

func _on_ValuesList_item_activated(index):
	_edited_index = index
	_edited_data = $Card/CardLayout/DataLayout/ValuesList.get_item_metadata(index)
	$Dialogs/ValueDialog.popup_centered_edit(_edited_data)
	
func _on_ValueDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_value(_edited_index, form["id"], form["value"])
	else:
		_append_value(form["id"], form["value"])

func _on_AddTxtBtn_pressed():
	$Dialogs/TextDialog.popup_centered()

func _on_TextsList_item_activated(index):
	_edited_index = index
	_edited_data = $Card/CardLayout/DataLayout/TextsList.get_item_metadata(index)
	$Dialogs/TextDialog.popup_centered_edit(_edited_data)
	
func _on_TextDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_text(_edited_index, form["id"], form["text"])
	else:
		_append_text(form["id"], form["text"])

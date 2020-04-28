tool
extends TabContainer
class_name CardEngineUI

var _selected_db = -1
var _edited_index = -1
var _edited_data = {}
var _selected_categ = -1
var _selected_val = -1
var _selected_text = -1

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

func _delete_database():
	if yield():
		CardEngine.db().delete_database(
			$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _load_card(id: String, db_id: String):
	$Cards/CardLayout/DataLayout/CategList.clear()
	$Cards/CardLayout/DataLayout/ValuesList.clear()
	$Cards/CardLayout/DataLayout/TextsList.clear()
	
	var db = CardEngine.db().get_database(db_id)
	var card = db.get_card(id)
	if card == null:
		$Cards/CardLayout/ToolLayout/ErrorLbl.text = "Unable to find the card in the database"
	else:
		$Cards/CardLayout/ToolLayout/CardId.text = card.id
		for categ in card.categories():
			_append_category(categ, card.get_category(categ))
		
		for value in card.values():
			_append_value(value, card.get_value(value))
		
		for text in card.texts():
			_append_text(text, card.get_text(text))

func _save_card(id: String, db: CardDatabase):
	var card = CardData.new(id)
	for i in range($Cards/CardLayout/DataLayout/CategList.get_item_count()):
		var data = $Cards/CardLayout/DataLayout/CategList.get_item_metadata(i)
		card.add_category(data["id"], data["name"])
	for i in range($Cards/CardLayout/DataLayout/ValuesList.get_item_count()):
		var data = $Cards/CardLayout/DataLayout/ValuesList.get_item_metadata(i)
		card.add_value(data["id"], data["value"])
	for i in range($Cards/CardLayout/DataLayout/TextsList.get_item_count()):
		var data = $Cards/CardLayout/DataLayout/TextsList.get_item_metadata(i)
		card.add_text(data["id"], data["text"])
	db.add_card(card)
	CardEngine.db().write_database(db)

func _overwrite_card(id: String, db: CardDatabase):
	if yield():
		_save_card(id, db)

func _delete_card(id: String, db_id: String):
	if yield():
		var db = CardEngine.db().get_database(db_id)
		db.remove_card(id)
		CardEngine.db().write_database(db)
		$Dialogs/EditDatabaseDialog.remove_selected_card()

func _append_category(id: String, name: String):
	var list = $Cards/CardLayout/DataLayout/CategList
	list.add_item("%s: %s" % [id, name])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "name": name})

func _replace_category(idx: int, id: String, name: String):
	var list = $Cards/CardLayout/DataLayout/CategList
	list.set_item_text(idx, "%s: %s" % [id, name])
	list.set_item_metadata(idx, {"id": id, "name": name})

func _delete_category(idx: int):
	if yield():
		$Cards/CardLayout/DataLayout/CategList.remove_item(idx)
		$Cards/CardLayout/DataLayout/CategToolLayout/DelCategBtn.disabled = true

func _append_value(id: String, value: float):
	var list = $Cards/CardLayout/DataLayout/ValuesList
	list.add_item("%s = %d" % [id, value])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "value": value})
	
func _replace_value(idx: int, id: String, value: float):
	var list = $Cards/CardLayout/DataLayout/ValuesList
	list.set_item_text(idx, "%s = %f" % [id, value])
	list.set_item_metadata(idx, {"id": id, "value": value})

func _delete_value(idx: int):
	if yield():
		$Cards/CardLayout/DataLayout/ValuesList.remove_item(idx)
		$Cards/CardLayout/DataLayout/ValuesToolLayout/DelValBtn.disabled = true
		
func _append_text(id: String, text: String):
	var list = $Cards/CardLayout/DataLayout/TextsList
	var lines = text.split("\n")
	if lines.size() > 1:
		list.add_item("%s: %s (...)" % [id, lines[0]])
	else:
		list.add_item("%s: %s" % [id, text])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "text": text})
	list.set_item_tooltip(list.get_item_count()-1, text)

func _replace_text(idx: int, id: String, text: String):
	var list = $Cards/CardLayout/DataLayout/TextsList
	var lines = text.split("\n")
	if lines.size() > 1:
		list.set_item_text(idx, "%s: %s (...)" % [id, lines[0]])
	else:
		list.set_item_text(idx, "%s: %s" % [id, text])
	list.set_item_metadata(idx, {"id": id, "text": text})
	list.set_item_tooltip(idx, text)

func _delete_text(idx: int):
	if yield():
		$Cards/CardLayout/DataLayout/TextsList.remove_item(idx)
		$Cards/CardLayout/DataLayout/TextsToolLayout/DelTxtBtn.disabled = true

func _on_CreateBtn_pressed():
	$Dialogs/NewDatabaseDialog.popup_centered()

func _on_Databases_changed():
	var list = $Databases/DatabaseLayout/DatabaseList
	var select = $Cards/CardLayout/ToolLayout/DatabaseSelect
	
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
	$Dialogs/GenericConfirmDialog.ask_confirmation("Database Delete", _delete_database())

func _on_DatabaseList_item_activated(index):
	$Dialogs/EditDatabaseDialog.popup_centered()
	$Dialogs/EditDatabaseDialog.set_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_SaveBtn_pressed():
	$Cards/CardLayout/ToolLayout/ErrorLbl.text = ""
	
	var id = $Cards/CardLayout/ToolLayout/CardId.text
	var db = CardEngine.db().get_database(
		$Cards/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())
	
	if db.card_exists(id):
		$Dialogs/GenericConfirmDialog.ask_confirmation("Overwrite Card", _overwrite_card(id, db))
	else:
		_save_card(id, db)

func _on_LoadBtn_pressed():
	$Cards/CardLayout/ToolLayout/ErrorLbl.text = ""
	
	_load_card(
		$Cards/CardLayout/ToolLayout/CardId.text,
		$Cards/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())

func _on_CardId_text_changed(new_text):
	if Utils.is_id_valid(new_text):
		$Cards/CardLayout/ToolLayout/SaveBtn.disabled = false
		$Cards/CardLayout/ToolLayout/LoadBtn.disabled = false
		$Cards/CardLayout/ToolLayout/ErrorLbl.text = ""
	else:
		$Cards/CardLayout/ToolLayout/SaveBtn.disabled = true
		$Cards/CardLayout/ToolLayout/LoadBtn.disabled = true
		$Cards/CardLayout/ToolLayout/ErrorLbl.text = "Invalid ID"

func _on_AddCategBtn_pressed():
	$Dialogs/CategoryDialog.popup_centered()

func _on_DelCategBtn_pressed():
	$Dialogs/GenericConfirmDialog.ask_confirmation("Delete Category", _delete_category(_selected_categ))

func _on_CategList_item_selected(index):
	$Cards/CardLayout/DataLayout/CategToolLayout/DelCategBtn.disabled = false
	_selected_categ = index
	
func _on_CategList_item_activated(index):
	_edited_index = index
	_edited_data = $Cards/CardLayout/DataLayout/CategList.get_item_metadata(index)
	$Dialogs/CategoryDialog.popup_centered_edit(_edited_data)

func _on_CategoryDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_category(_edited_index, form["id"], form["name"])
	else:
		_append_category(form["id"], form["name"])

func _on_AddValBtn_pressed():
	$Dialogs/ValueDialog.popup_centered()

func _on_DelValBtn_pressed():
	$Dialogs/GenericConfirmDialog.ask_confirmation("Delete Value", _delete_value(_selected_val))

func _on_ValuesList_item_selected(index):
	$Cards/CardLayout/DataLayout/ValuesToolLayout/DelValBtn.disabled = false
	_selected_val = index

func _on_ValuesList_item_activated(index):
	_edited_index = index
	_edited_data = $Cards/CardLayout/DataLayout/ValuesList.get_item_metadata(index)
	$Dialogs/ValueDialog.popup_centered_edit(_edited_data)
	
func _on_ValueDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_value(_edited_index, form["id"], form["value"])
	else:
		_append_value(form["id"], form["value"])

func _on_AddTxtBtn_pressed():
	$Dialogs/TextDialog.popup_centered()

func _on_DelTxtBtn_pressed():
	$Dialogs/GenericConfirmDialog.ask_confirmation("Delete Text", _delete_text(_selected_text))

func _on_TextsList_item_selected(index):
	$Cards/CardLayout/DataLayout/TextsToolLayout/DelTxtBtn.disabled = false
	_selected_text = index

func _on_TextsList_item_activated(index):
	_edited_index = index
	_edited_data = $Cards/CardLayout/DataLayout/TextsList.get_item_metadata(index)
	$Dialogs/TextDialog.popup_centered_edit(_edited_data)
	
func _on_TextDialog_form_validated(form):
	if form["edit"] && _edited_data["id"] == form["id"]:
		_replace_text(_edited_index, form["id"], form["text"])
	else:
		_append_text(form["id"], form["text"])

func _on_EditDatabaseDialog_edit_card(card, db):
	current_tab = 1
	_load_card(card, db)
	$Cards/CardLayout/ToolLayout/SaveBtn.disabled = false

func _on_EditDatabaseDialog_delete_card(card, db):
	$Dialogs/GenericConfirmDialog.ask_confirmation("Delete Card", _delete_card(card, db))

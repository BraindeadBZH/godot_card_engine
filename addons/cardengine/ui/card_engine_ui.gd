tool
extends Control
class_name CardEngineUI

var _selected_db = -1

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

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
	$Dialogs/DeleteDatabaseDialog.popup_centered()

func _on_DeleteDatabaseDialog_form_validated(form):
	CardEngine.db().delete_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_DatabaseList_item_activated(index):
	$Dialogs/EditDatabaseDialog.popup_centered()
	$Dialogs/EditDatabaseDialog.set_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_SaveBtn_pressed():
	$Card/CardLayout/ToolLayout/ErrorLbl.text = ""
	
	var id = $Card/CardLayout/ToolLayout/CardId.text
	var db = CardEngine.db().get_database(
		$Card/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())
	
	var card = CardData.new(id)
	for i in range($Card/CardLayout/DataLayout/CategList.get_item_count()):
		var data = $Card/CardLayout/DataLayout/CategList.get_item_metadata(i)
		card.add_category(data["id"], data["name"])
	db.add_card(card)
	CardEngine.db().write_database(db)

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
			_append_category(value, card.get_value(value))
		
		for text in card.texts():
			_append_category(text, card.get_text(text))
	
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

func _on_CategoryDialog_form_validated(form):
	_append_category(form["id"], form["name"])

func _append_category(id: String, name: String):
	var list = $Card/CardLayout/DataLayout/CategList
	list.add_item("%s: %s" % [id, name])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "name": name})

func _append_value(id: String, value: float):
	var list = $Card/CardLayout/DataLayout/ValuesList
	list.add_item("%s = %f" % [id, value])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "value": value})

func _append_text(id: String, text: String):
	var list = $Card/CardLayout/DataLayout/TextsList
	list.add_item("%s: %s" % [id, text])
	list.set_item_metadata(list.get_item_count()-1, {"id": id, "text": text})

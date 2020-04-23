tool
extends Control
class_name CardEngineUI

var _selected_db = -1

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

func _on_CreateBtn_pressed():
	$Dialogs/NewDatabaseDialog.popup_centered()

func _on_Databases_changed():
	$Databases/DatabaseLayout/DatabaseList.clear()
	$Databases/DatabaseLayout/Toolbar/DeleteBtn.disabled = true
	
	$Card/CardLayout/ToolLayout/DatabaseSelect.clear()
	
	var databases = CardEngine.db().databases()
	for id in databases:
		var db = databases[id]
		$Databases/DatabaseLayout/DatabaseList.add_item(db.id + " - " + db.name)
		$Databases/DatabaseLayout/DatabaseList.set_item_metadata(
			$Databases/DatabaseLayout/DatabaseList.get_item_count()-1, db.id)
			
		$Card/CardLayout/ToolLayout/DatabaseSelect.add_item(db.id + " - " + db.name)
		$Card/CardLayout/ToolLayout/DatabaseSelect.set_item_metadata(
			$Card/CardLayout/ToolLayout/DatabaseSelect.get_item_count()-1, db.id)

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
		pass # TODO
	
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
	$Card/CardLayout/DataLayout/CategList.add_item(form["id"] + " - " + form["name"])
	$Card/CardLayout/DataLayout/CategList.set_item_metadata(
		$Card/CardLayout/DataLayout/CategList.get_item_count()-1, form)

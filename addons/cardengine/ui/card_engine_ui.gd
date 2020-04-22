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

func _on_NewDatabaseDialog_creation_confirmed(id, name):
	CardEngine.db().create_database(id, name)

func _on_DatabaseList_item_selected(index):
	_selected_db = index
	$Databases/DatabaseLayout/Toolbar/DeleteBtn.disabled = false

func _on_DeleteBtn_pressed():
	$Dialogs/DeleteDatabaseDialog.popup_centered()

func _on_DeleteDatabaseDialog_deletion_confirmed():
	CardEngine.db().delete_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_DatabaseList_item_activated(index):
	$Dialogs/EditDatabaseDialog.popup_centered()
	$Dialogs/EditDatabaseDialog.set_database(
		$Databases/DatabaseLayout/DatabaseList.get_item_metadata(_selected_db))

func _on_SaveBtn_pressed():
	var id = $Card/CardLayout/ToolLayout/CardId.text
	var db = CardEngine.db().get_database(
		$Card/CardLayout/ToolLayout/DatabaseSelect.get_selected_metadata())
	
	var card = CardData.new(id)
	db.add_card(card)
	CardEngine.db().write_database(db)

func _on_CardId_text_changed(new_text):
	if Utils.is_id_valid(new_text):
		$Card/CardLayout/ToolLayout/SaveBtn.disabled = false
	else:
		$Card/CardLayout/ToolLayout/SaveBtn.disabled = true

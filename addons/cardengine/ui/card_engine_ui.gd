tool
extends Control
class_name CardEngineUI

func _ready():
	CardEngine.db().connect("changed", self, "_on_Databases_changed")

func _on_CreateBtn_pressed():
	$Dialogs/NewDatabaseDialog.popup_centered()

func _on_Databases_changed():
	$Databases/DatabaseLayout/DatabaseList.clear()
	var databases = CardEngine.db().get_databases()
	for id in databases:
		var db = databases[id]
		$Databases/DatabaseLayout/DatabaseList.add_item(db.id + " - " + db.name)

func _on_NewDatabaseDialog_creation_confirmed(id, name):
	CardEngine.db().create_database(id, name)

extends AbstractScreen

onready var _display = $HomeDisplay


func _ready():
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var store = CardPile.new()
	
	q.from(["common"])
	db.exec_query(q, store)
	store.shuffle()
	store.keep(3)
	_display.set_store(store)


func _on_NewGameBtn_pressed() -> void:
	emit_signal("next_screen", "new_game")


func _on_LibraryBtn_pressed() -> void:
	emit_signal("next_screen", "library")


func _on_QuitBtn_pressed() -> void:
	get_tree().quit()

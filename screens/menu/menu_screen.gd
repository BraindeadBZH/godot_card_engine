extends AbstractScreen

onready var _display = $HomeDisplay


func _ready():
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var store = CardPile.new()
	
	var cards = q.from(["rarity:common"]).execute(db)
	
	store.populate(db, cards)
	store.shuffle()
	store.keep(3)
	
	_display.set_store(store)


func _on_NewGameBtn_pressed() -> void:
	emit_signal("next_screen", "new_game")


func _on_LibraryBtn_pressed() -> void:
	emit_signal("next_screen", "library")


func _on_QuitBtn_pressed() -> void:
	get_tree().quit()

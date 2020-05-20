extends AbstractScreen

onready var _container = $LibraryBg/LibraryScroll/LibraryContainer

func _ready():
	_container.set_store(CardDeck.new())

func _on_BackBtn_pressed():
	emit_signal("next_screen", "menu")

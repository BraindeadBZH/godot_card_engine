extends AbstractScreen

var _hand: CardHand = CardHand.new()

onready var _hand_cont = $HandZone/HandContainer


func _ready() -> void:
	var db = CardEngine.db().get_database("main")
	
	_hand.populate_all(db)
	_hand.keep(8)
	_hand_cont.set_store(_hand)


func _on_MenuBtn_pressed() -> void:
	emit_signal("next_screen", "menu")

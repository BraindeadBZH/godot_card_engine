extends AbstractScreen

var _hand_store: CardHand = CardHand.new()
var _pile1_store: CardPile = CardPile.new()
var _pile2_store: CardPile = CardPile.new()
var _pile3_store: CardPile = CardPile.new()

onready var _hand = $Board/Hand
onready var _pile1 = $Board/Pile1
onready var _pile2 = $Board/Pile2
onready var _pile3 = $Board/Pile3


func _ready() -> void:
	var db = CardEngine.db().get_database("main")

	_hand_store.populate_all(db)
	_hand_store.keep(8)

	_hand.set_store(_hand_store)

	_pile1.data_id = "pile_1"
	_pile2.data_id = "pile_2"
	_pile3.data_id = "pile_3"

	_pile2.set_drag_enabled(false)
	_pile2.set_interactive(false)

	_pile1.get_drop_area().set_source_filter(["hand"])
	_pile2.get_drop_area().set_source_filter(["hand", "pile_1"])
	_pile3.get_drop_area().set_source_filter(["hand", "pile_1"])

	_pile1.set_store(_pile1_store)
	_pile2.set_store(_pile2_store)
	_pile3.set_store(_pile3_store)


func _on_MenuButton_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_Pile1_card_dropped(card: CardInstance, source: String, _on_card: CardInstance) -> void:
	if source == "hand":
		_hand_store.play_card(card.ref(), _pile1_store)
	else:
		return


func _on_Pile2_card_dropped(card: CardInstance, source: String, _on_card: CardInstance) -> void:
	if source == "hand":
		_hand_store.play_card(card.ref(), _pile2_store)
	elif source == "pile_1":
		# warning-ignore:return_value_discarded
		_pile1_store.move_card(card.ref(), _pile2_store)
	else:
		return


func _on_Pile3_card_dropped(card: CardInstance, source: String, _on_card: CardInstance) -> void:
	if source == "hand":
		_hand_store.play_card(card.ref(), _pile3_store)
	elif source == "pile_1":
		# warning-ignore:return_value_discarded
		_pile1_store.move_card(card.ref(), _pile3_store)
	else:
		return


func _on_DiscardBtn_pressed() -> void:
	var card := _hand_store.get_last()
	if card != null:
		# warning-ignore:return_value_discarded
		_hand_store.move_card(card.ref(), _pile3_store)


func _on_ShuffleBtn_pressed() -> void:
	_pile3_store.shuffle()


func _on_DrawBtn_pressed() -> void:
	var card := _pile3_store.get_last()
	if card != null:
		# warning-ignore:return_value_discarded
		_pile3_store.move_card(card.ref(), _hand_store)

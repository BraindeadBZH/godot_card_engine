extends AbstractScreen

const STARTING_HAND_SIZE: int = 3
const MAX_HAND_SIZE: int = 8

var _hand: CardHand = CardHand.new()
var _draw_pile: CardPile = CardPile.new()
var _discard_pile: CardPile = CardPile.new()

onready var _hand_cont = $HandZone/HandContainer
onready var _draw_count = $DeckZone/DrawCount
onready var _draw_btn = $DeckZone/DrawBtn
onready var _discard_count = $DiscardZone/DiscardCount
onready var _reshuffle_btn = $DiscardZone/ReshuffleBtn
onready var _hand_delay = $StartingHandDelay


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_draw_pile.connect("changed", self, "_on_DrawPile_changed")
	# warning-ignore:return_value_discarded
	_discard_pile.connect("changed", self, "_on_DiscardPile_changed")
	
	var db = CardEngine.db().get_database("main")
	
	_draw_pile.populate_all(db)
	_draw_pile.shuffle()
	
	_hand_cont.set_store(_hand)


func _on_MenuBtn_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_DrawPile_changed() -> void:
	_draw_count.text = "%d" % _draw_pile.count()


func _on_DiscardPile_changed() -> void:
	_discard_count.text = "%d" % _discard_pile.count()


func _on_StartingHandDelay_timeout() -> void:
	
	var card = _draw_pile.draw()
	
	if card == null:
		return
		
	_hand.add_card(card)
	
	if _hand.count() >= STARTING_HAND_SIZE:
		_hand_delay.stop()
	else:
		_hand_delay.start(0.75)


func _on_DrawBtn_pressed() -> void:
	var card = _draw_pile.draw()
	
	if card == null:
		return
	
	_hand.add_card(card)
	
	if _hand.count() >= MAX_HAND_SIZE:
		_draw_btn.disabled = true

# CardPile class - Holds not playable cards during a game
extends "card_container.gd"

# Imports
var CardRng = preload("card_rng.gd")

signal card_drawn()

var _rng = CardRng.new()

func _init():
	_rng.set_seed(CardEngine.master_rng().randomi())

# Randomizes the card order in the pile
func shuffle():
	var shuffled = []
	for card in _cards:
		shuffled.insert(_rng.randomf()*shuffled.size(), card)
	_cards = shuffled

# Draw the top card of the pile
func draw():
	if _cards.empty(): return null
	var card = _cards.pop_back()
	emit_signal("size_changed", size())
	emit_signal("card_drawn")
	return card


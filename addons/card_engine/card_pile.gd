# CardPile class - Holds not playable cards during a game
extends "card_container.gd"

# Randomizes the card order in the pile
func shuffle():
	var shuffled = []
	for card in _cards:
		shuffled.insert(randf()*shuffled.size(), card)
	_cards = shuffled

# Draw the top card of the pile
func draw():
	if _cards.empty(): return null
	var card = _cards.pop_back()
	emit_signal("size_changed", size())
	return card


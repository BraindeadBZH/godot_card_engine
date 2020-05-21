class_name CardPile
extends AbstractStore
# Manage unplayable cards that can be drawn, also store discarded/played cards

signal shuffled()
signal card_drawn()


func shuffle() -> void:
	var shuffled = []
	for card in _cards:
		shuffled.insert(rng().randomf() * shuffled.size(), card)
	replace_cards(shuffled)
	emit_signal("shuffled")


func draw() -> CardData:
	if is_empty():
		return null
	
	var card = get_last()
	remove_last()
	emit_signal("card_drawn")
	
	return card

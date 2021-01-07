class_name CardPile
extends AbstractStore
# Manage unplayable cards that can be drawn, also store discarded/played cards

signal shuffled()
signal card_drawn()


func shuffle() -> void:
	randomize()
	_cards.shuffle()
	emit_signal("shuffled")
	emit_signal("changed")


func draw() -> CardInstance:
	if is_empty():
		return null

	var card = get_last()
	remove_last()
	emit_signal("card_drawn")
	emit_signal("changed")

	return card

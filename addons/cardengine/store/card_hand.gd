class_name CardHand
extends AbstractStore
# Manage playable cards

signal card_played(index)


func play_card(index: int, discard_pile: AbstractStore = null) -> CardData:
	if index < 0 or index >= count():
		return null
	
	var card = get_card(index)
	remove_card(index)
	
	if discard_pile != null:
		discard_pile.add_card(card)
	
	emit_signal("card_played", index)
	
	return card

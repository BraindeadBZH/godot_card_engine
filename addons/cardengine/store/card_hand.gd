class_name CardHand
extends AbstractStore
# Manage playable cards

signal card_played(ref)


func play_card(card: CardInstance, discard_pile: AbstractStore = null) -> void:
	remove_card(card.ref())
	
	if discard_pile != null:
		discard_pile.add_card(card)
	
	emit_signal("card_played", card.ref())

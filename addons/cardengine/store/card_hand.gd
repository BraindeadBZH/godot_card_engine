class_name CardHand
extends AbstractStore
# Manage playable cards

signal card_played(ref)


func play_card(ref: int, discard_pile: AbstractStore = null) -> void:
	if discard_pile != null:
		discard_pile.add_card(get_card(_ref2idx(ref)))

	remove_card(ref)

	emit_signal("card_played", ref)

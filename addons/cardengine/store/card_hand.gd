class_name CardHand
extends AbstractStore
# Manage playable cards

signal card_played(ref)


func play_card(ref: int, discard_pile: AbstractStore = null) -> void:
	if discard_pile != null:
		move_card(ref, discard_pile)
	else:
		remove_card(ref)

	emit_signal("card_played", ref)

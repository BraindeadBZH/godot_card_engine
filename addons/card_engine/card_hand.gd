# CardHand class - Holds the playable cards during a game
extends "card_container.gd"

# Discards the card at the given index en returns it
func discard(index):
	var card = self.card(index)
	remove(index)
	return card
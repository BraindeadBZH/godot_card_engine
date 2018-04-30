# CardDeck class - Holds all the card available for a game
extends "card_container.gd"

var id = ""

# Creates a copy of the deck, necessary if you don't want to modify the original deck
func duplicate():
	var copy = get_script().new()
	
	copy.id = id
	copy._cards = duplicate_cards()
	
	return copy

# CardEngine class - Singleton keeping track of the CardEngine state
extends Node

var CardDeck = preload("card_deck.gd")
var CardPile = preload("card_pile.gd")
var CardHand = preload("card_hand.gd")
var CardData = preload("card_data.gd")

# The Library is created as a singleton
var _library = preload("card_library.gd").new()

# Intializes CardEngine
func _init():
	_library.load_from_database(CEInterface.database_path())

# Returns the Library singleton
func library():
	return _library

# Returns the path to the image with the given type and id
func card_image(img_type, img_id):
	return CEInterface.card_image(img_type, img_id)

# Returns the given value with buffs/debuffs taken into account
func final_value(card_data, value):
	if !card_data.values.has(value):
		return 0
	else:
		return CEInterface.calculate_final_value(card_data, value)

# Returns the given text with placeholders replaced with the corresponding final value
func final_text(card_data, text):
	var final_text = card_data.texts[text]
	for value in card_data.values:
		final_text = final_text.replace("$%s" % value, "%d" % final_value(card_data, value))
	return final_text

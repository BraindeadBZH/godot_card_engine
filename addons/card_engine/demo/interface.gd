# CEInterface class - Serves as an interface between your game and CardEngine
extends Node

# TODO: make a template out of this file before releasing the plugin

# Folders
const FOLDER_IMAGES = "res://addons/card_engine/demo/cards/images"

# Filename formats
const FORMAT_IMAGE = "card-%s-%s.png"

# Players name
const PLAYER_PLAYER = "player"
const PLAYER_ENEMY  = "enemy"

# Decks name
const DECK_PLAYER = "player_deck"

# Piles name
const PILE_DRAW    = "draw_pile"
const PILE_DISCARD = "discard_pile"

var _custom_card = preload("res://addons/card_engine/demo/custom_card.tscn")

# Returns the path to the file containing the card database
func database_path():
	return "res://addons/card_engine/demo/cards.json"

# Returns the path to the image with the given type and id
func card_image(img_type, img_id):
	var filename = FORMAT_IMAGE % [img_type, img_id]
	return "%s/%s" % [FOLDER_IMAGES, filename]

# Calculate the the given value of the given card taking into account possible buffs/debuffs
func calculate_final_value(card_data, value):
	# TODO: take into account buffs/debuffs
	return card_data.values[value]

# Returns an instance of the custom card design
func card_instance():
	return _custom_card.instance()

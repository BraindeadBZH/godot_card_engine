# CEInterface - Serves as an interface between your game and CardEngine
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

# Constant values
const HAND_SIZE = 5

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

# Called by CardEngine to execute custom actions during the game creation
func new_game_callback(parameters):
	CardEngine.add_player(PLAYER_PLAYER)
	
	# Preparing player's deck
	CardEngine.player(PLAYER_PLAYER).add_deck(DECK_PLAYER)
	CardEngine.player(PLAYER_PLAYER).deck(DECK_PLAYER).copy_from(CardEngine.library().deck(parameters["deck"]))
	
	CardEngine.player(PLAYER_PLAYER).add_pile(PILE_DRAW)
	CardEngine.player(PLAYER_PLAYER).add_pile(PILE_DISCARD)
	
	# Immediately start a match
	CardEngine.start_match({})

# Called by CardEngine to exectute custom actions when a match is created
func new_match_callback(parameters):
	CardEngine.add_player(PLAYER_ENEMY)

# Called by CardEngine to execute custom actions for every player when a match is created
func player_new_match_callback(player):
	if player.id == PLAYER_PLAYER:
		player.pile(PILE_DRAW).copy_from(player.deck(DECK_PLAYER))
		player.pile(PILE_DRAW).shuffle()

# Called by CardEngine to execute custom actions when a match is about to start
func match_start_callback():
	for i in range(HAND_SIZE):
		CardEngine.player(PLAYER_PLAYER).hand().append(CardEngine.player(PLAYER_PLAYER).pile(PILE_DRAW).draw())


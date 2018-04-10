# CardEngine class - Singleton keeping track of the CardEngine state
extends Node

# Imports
var CardPlayer = preload("card_player.gd")

# The seed used for the game
var game_seed = 0 setget set_game_seed,get_game_seed

# The Library is created as a singleton
var _library = preload("card_library.gd").new()

# The different players for the current game
var _players = {}

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

# Sets the seed used for CardEngine randomization
func set_game_seed(new_seed):
	game_seed = int(new_seed)
	rand_seed(game_seed)
	print("Game seed set to '%d'" % game_seed)

# Returns the seed used for CardEngine randomization
func get_game_seed():
	return game_seed

# Start a game with the given parameters
func start_game(parameters):
	randomize()
	set_game_seed(randi())
	_players.clear()
	CEInterface.new_game_callback(parameters)

# Start a match inside the current game
func start_match(parameters):
	CEInterface.new_match_callback(parameters)
	# Prepares players for a new match
	for player_id in _players:
		CEInterface.player_new_match_callback(_players[player_id])
	CEInterface.match_start_callback()

# Adds a new player to the current game
func add_player(player_id):
	var player = CardPlayer.new()
	player.id = player_id
	_players[player_id] = player

# Returns the given player, or null if does not exists
func player(player_id):
	if !_players.has(player_id): return null
	return _players[player_id]

# Removes a player from the current game
func remove_player(player_id):
	if !_players.has(player_id): return
	_players.erase(player_id)

# DemoGame class - Contains the game logic for the demo game
extends Node

# Imports
var CardHand = preload("../card_hand.gd")
var CardPile = preload("../card_pile.gd")

signal player_energy_changed()

# Constant values
const HAND_SIZE = 5

var player_deck    = null
var player_hand    = CardHand.new()
var player_draw    = CardPile.new()
var player_discard = CardPile.new()

var player_energy     = 3
var player_max_energy = 3

# Creates a new game with the given deck
func create_game(deck_id):
	player_deck = CardEngine.library().deck(deck_id)
	if player_deck == null:
		printerr("Invalid deck ID while creating a game")
	
	player_hand.clear()
	player_draw.clear()
	player_discard.clear()
	
	player_draw.copy_from(player_deck)
	player_draw.shuffle()
	
	for i in range(HAND_SIZE):
		player_hand.append(player_draw.draw())
		

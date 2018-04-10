# CardPlayer class - Defines a player who can take part of a game
extends Reference

# Imports
var CardDeck = preload("card_deck.gd")
var CardPile = preload("card_pile.gd")
var CardHand = preload("card_hand.gd")
var CardData = preload("card_data.gd")

signal energy_changed()

# Indentifies the player
var id = ""

# The maximum and current energy the player has
var max_energy     = 3
var current_energy = 3

# The decks used for the game
var _decks = {}

# The piles used for the game
var _piles = {}

# The hand from which the player can play card
var _hand = CardHand.new()

# Adds a new empty deck to the player
func add_deck(deck_id):
	_decks[deck_id] = CardDeck.new()

# Returns the given deck
func deck(deck_id):
	if !_decks.has(deck_id): return null
	return _decks[deck_id]

# Removes a deck from the player
func remove_deck(deck_id):
	if !_decks.has(deck_id): return
	_decks.erase(deck_id)

# Adds a new empty pile to the player
func add_pile(pile_id):
	_piles[pile_id] = CardPile.new()

# Returns the given pile
func pile(pile_id):
	if !_piles.has(pile_id): return null
	return _piles[pile_id]

# Removes a pile from the player
func remove_pile(pile_id):
	if !_piles.has(pile_id): return
	_piles.erase(pile_id)

# Returns the player's hand
func hand():
	return _hand;

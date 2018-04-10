# CardContainer class - Base class for all classes storing cards
extends Reference

signal size_changed(new_size)

var CardData = preload("card_data.gd")

var _cards = []

# Adds a card to the container
func append(card_data):
	# Skip append if the parameter is not of the CardData type
	if card_data == null || !card_data is CardData: return
	_cards.append(card_data)
	emit_signal("size_changed", size())

# Returns all the card as an array
func cards():
	return _cards

# Returns the card at the given index or null if does not exist
func card(index):
	if index < 0 || index >= _cards.size():
		return null
	else:
		return _cards[index]

# Creates and returns a duplicate of the cards in the containers
func duplicate_cards():
	var copy = []
	
	for card in _cards:
		copy.append(card.duplicate())
	
	return copy

# Fill the container with a copy of the cards from another container
func copy_from(container):
	_cards = container.duplicate_cards()
	emit_signal("size_changed", size())

# Returns the first card of the container or null if container is empty
func first_card():
	if _cards.empty():
		return null
	else:
		return _cards.front()

# Returns the last card of the container or null if container is empty
func last_card():
	if _cards.empty():
		return null
	else:
		return _cards.back()

# Gives the number of cards in the container
func size():
	return _cards.size()

# Returns true if the container is empty, false otherwise
func empty():
	return _cards.empty()

# Removes all cards from the container
func clear():
	_cards.clear()
	emit_signal("size_changed", size())
	
# Removes the card at the given index from the container
func remove(index):
	_cards.remove(index)
	emit_signal("size_changed", size())

# Removes the first card from the container
func remove_first():
	_cards.pop_front()
	emit_signal("size_changed", size())

# Removes the lase card from the container
func remove_last():
	_cards.pop_back()
	emit_signal("size_changed", size())
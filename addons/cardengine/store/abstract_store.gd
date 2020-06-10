class_name AbstractStore
extends Reference
# Base class for in-memory card handling

signal card_added()
signal card_removed(index)
signal card_replaced()
signal cleared()

var _cards: Array = []
var _categs: Dictionary = {}
var _rng: PseudoRng = PseudoRng.new()


func cards() -> Array:
	return _cards


func clear() -> void:
	_cards.clear()
	_categs.clear()
	emit_signal("cleared")


func replace_cards(new_cards: Array) -> void:
	_cards = new_cards
	emit_signal("card_replaced")
	_update_categories()


func count() -> int:
	return _cards.size()


func is_empty() -> bool:
	return _cards.empty()


func get_card(index: int) -> CardData:
	if index < 0 or index >= _cards.size():
		return null
	
	return _cards[index]


func get_first() -> CardData:
	return _cards.front()


func get_last() -> CardData:
	return _cards.back()


func categories() -> Dictionary:
	return _categs


func get_category(id: String) -> Dictionary:
	if not _categs.has(id):
		return {}
	
	return _categs[id]


func add_card(card: CardData) -> void:
	_cards.append(card)
	emit_signal("card_added")
	_update_categories()


func remove_card(index: int) -> void:
	if index < 0 or index >= _cards.size():
		return
	
	_cards.remove(index)
	emit_signal("card_removed", index)
	_update_categories()


func remove_first() -> void:
	_cards.pop_front()
	emit_signal("card_removed", 0)
	_update_categories()


func remove_last() -> void:
	_cards.pop_back()
	emit_signal("card_removed", count()-1)
	_update_categories()


func move_card(index: int, to: AbstractStore = null) -> CardData:
	if index < 0 or index >= count():
		return null
	if to == null:
		return null
	
	var card = get_card(index)
	to.add_card(card)
	_cards.remove(index)
	emit_signal("card_removed", index)
	_update_categories()
	return card


func move_random_card(to: AbstractStore = null) -> CardData:
	return move_card(_rng.random_range(0, count()-1), to)


func copy_card(index: int, to: AbstractStore = null) -> CardData:
	if index < 0 || index >= _cards.size():
		return null
	if to == null:
		return null
	
	var card = get_card(index).duplicate()
	to.add_card(card)
	return card


func copy_random_card(to: AbstractStore = null) -> CardData:
	return copy_card(_rng.random_range(0, count()-1), to)


func rng() -> PseudoRng:
	return _rng


func _update_categories():
	_categs.clear()
	
	for card in _cards:
		for categ in card.categories():
			if _categs.has(categ):
				_categs[categ]["count"] += 1
			else:
				_categs[categ] = {
					"name": card.get_category(categ),
					"count": 1,
				}

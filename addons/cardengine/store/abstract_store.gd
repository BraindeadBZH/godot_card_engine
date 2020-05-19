extends Reference
class_name AbstractStore

# Base class for in-memory card handling

signal card_added()
signal card_removed(index)
signal card_replaced()

var _cards: Array = []
var _rng: PseudoRng = PseudoRng.new()

func cards() -> Array:
	return _cards

func replace_cards(new_cards: Array) -> void:
	_cards = new_cards
	emit_signal("card_replaced")

func count() -> int:
	return _cards.size()

func is_empty() -> bool:
	return _cards.empty()

func get_card(index: int) -> CardData:
	if index < 0 || index >= _cards.size(): return null
	
	return _cards[index]

func get_first() -> CardData:
	return _cards.front()

func get_last() -> CardData:
	return _cards.back()

func add_card(card: CardData) -> void:
	_cards.append(card)
	emit_signal("card_added")

func remove_card(index: int) -> void:
	if index < 0 || index >= _cards.size(): return
	
	_cards.remove(index)
	emit_signal("card_removed", index)

func remove_first() -> void:
	_cards.pop_front()
	emit_signal("card_removed", 0)

func remove_last() -> void:
	_cards.pop_back()
	emit_signal("card_removed", count()-1)

func move_card(index: int, to: AbstractStore = null) -> CardData:
	if index < 0 || index >= count(): return null
	if to == null: return null
	
	var card = get_card(index)
	if to != null: to.add_card(card)
	_cards.remove(index)
	emit_signal("card_removed", index)
	return card

func move_random_card(to: AbstractStore = null) -> CardData:
	return move_card(_rng.random_range(0, count()-1), to)

func copy_card(index: int, to: AbstractStore = null) -> CardData:
	if index < 0 || index >= _cards.size(): return null
	if to == null: return null
	
	var card = get_card(index).duplicate()
	if to != null: to.add_card(card)
	return card

func copy_random_card(to: AbstractStore = null) -> CardData:
	return copy_card(_rng.random_range(0, count()-1), to)

func rng() -> PseudoRng:
	return _rng

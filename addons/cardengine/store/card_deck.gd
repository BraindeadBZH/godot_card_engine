class_name CardDeck
extends AbstractStore
# Manage available cards a game

signal sorted()


class DeckIdSorter:
	func sort_ascending(left: CardData, right: CardData) -> bool:
		if left.id.casecmp_to(right.id) == -1:
			return true
		
		return false
	
	
	func sort_descending(left: CardData, right: CardData) -> bool:
		if left.id.casecmp_to(right.id) == 1:
			return true
		
		return false


class DeckValueSorter:
	var _value: String = ""
	
	
	func _init(value: String):
		_value = value
	
	
	func sort_ascending(left: CardData, right: CardData) -> bool:
		if not left.has_value(_value) or not right.has_value(_value):
			return false
		
		if left.get_value(_value) < right.get_value(_value):
			return true
		
		return false
	
	
	func sort_descending(left: CardData, right: CardData) -> bool:
		if not left.has_value(_value) or not right.has_value(_value):
			return false
		
		if left.get_value(_value) > right.get_value(_value):
			return true
		
		return false


func sort_by_id(ascending: bool = true):
	var sorter = DeckIdSorter.new()
	if ascending:
		_cards.sort_custom(sorter, "sort_ascending")
	else:
		_cards.sort_custom(sorter, "sort_descending")
	emit_signal("sorted")


func sort_by_value(value: String, ascending: bool = true):
	var sorter = DeckValueSorter.new(value)
	if ascending:
		_cards.sort_custom(sorter, "sort_ascending")
	else:
		_cards.sort_custom(sorter, "sort_descending")
	emit_signal("sorted")


func fill_random(amount: int, store: AbstractStore, allow_duplicate: bool = false) -> void:
	var selected = []
	while selected.size() < amount:
		var index = rng().random_range(0, count()-1)
		
		if !allow_duplicate and selected.has(index):
			continue
		
		store.add_card(get_card(index).duplicate())
		selected.append(index)

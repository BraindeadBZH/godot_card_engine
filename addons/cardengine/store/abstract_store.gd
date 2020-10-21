class_name AbstractStore
extends Reference
# Base class for in-memory card handling
# TODO: add sorting

signal card_added()
signal card_removed(index)
signal cards_removed()
signal filtered()
signal cleared()

var _cards: Array = []
var _filtered: Array = []
var _categs: Dictionary = {}
var _values: Array = []
var _texts: Array = []
var _rng: PseudoRng = PseudoRng.new()
var _filter: Query = null


func cards() -> Array:
	if _filter == null:
		return _cards
	else:
		return _filtered


func clear() -> void:
	_cards.clear()
	_filtered.clear()
	_categs.clear()
	_values.clear()
	_texts.clear()
	_filter = null
	emit_signal("cleared")


func populate(db: CardDatabase, ids: Array = []) -> void:
	clear()
	if ids.empty():
		ids = db.cards().keys()
		
	for id in ids:
		add_card(CardInstance.new(db.get_card(id)))


func apply_filter(filter: Query) -> void:
	_filter = filter
	_update_filtered()
	emit_signal("filtered")


func count() -> int:
	if _filter == null:
		return _cards.size()
	else:
		return _filtered.size()


func is_empty() -> bool:
	if _filter == null:
		return _cards.empty()
	else:
		return _filtered.empty()


func has_card(search: CardInstance) -> bool:
	var c = _cards
	if _filter != null:
		c = _filtered
		
	for card in c:
		if card.ref() == search.ref():
			return true
	
	return false


func get_card(index: int) -> CardInstance:
	if _filter == null and (index < 0 or index >= _cards.size()):
		return null
	if _filter != null and (index < 0 or index >= _filtered.size()):
		return null
	
	if _filter == null:
		return _cards[index]
	else:
		return _filtered[index]


func get_first() -> CardInstance:
	if _filter == null:
		return _cards.front()
	else:
		return _filtered.front()


func get_last() -> CardInstance:
	if _filter == null:
		return _cards.back()
	else:
		return _filtered.back()


func categories() -> Dictionary:
	return _categs


func get_category(id: String) -> Dictionary:
	if not _categs.has(id):
		return {}
	
	return _categs[id]


func values() -> Array:
	return _values


func texts() -> Array:
	return _texts


func add_card(card: CardInstance) -> void:
	_cards.append(card)
	emit_signal("card_added")
	_update_stats()
	_update_filtered()


func remove_card(ref: int) -> void:
	var index: int = _ref2idx(ref)
	
	if index >= 0:
		_cards.remove(index)
		emit_signal("card_removed", index)
		_update_stats()
		_update_filtered()


func remove_first() -> void:
	_cards.pop_front()
	emit_signal("card_removed", 0)
	_update_stats()
	_update_filtered()


func remove_last() -> void:
	_cards.pop_back()
	emit_signal("card_removed", count()-1)
	_update_stats()
	_update_filtered()


func move_card(ref: int, to: AbstractStore = null) -> CardInstance:
	var index: int = _ref2idx(ref)
	
	if index >= 0:
		var card = _cards[index]
		to.add_card(card)
		_cards.remove(index)
		emit_signal("card_removed", index)
		_update_stats()
		_update_filtered()
		return card
	
	return null


func move_random_card(to: AbstractStore = null) -> CardInstance:
	return move_card(_rng.random_range(0, count()-1), to)


func copy_card(ref: int, to: AbstractStore = null) -> CardInstance:
	var index: int = _ref2idx(ref)
	
	if index >= 0:
		var card = _cards[index].duplicate()
		to.add_card(card)
		return card
	
	return null


func copy_random_card(to: AbstractStore = null) -> CardInstance:
	return copy_card(_rng.random_range(0, _cards.size()-1), to)


func rng() -> PseudoRng:
	return _rng


func keep(count: int) -> void:
	if count > _cards.size():
		return
	_cards.resize(count)
	emit_signal("cards_removed")
	_update_stats()
	_update_filtered()


func _ref2idx(ref: int) -> int:
	var search: int = 0
	
	for card in _cards:
		if card.reference() == ref:
			return search
		
		search += 1
	
	return -1


func _update_filtered():
	_filtered.clear()
		
	if _filter == null:
		_filtered = _cards.duplicate()
	else:
		for card in _cards:
			if _filter.match_card(card.data()):
				_filtered.append(card)


func _update_stats():
	_update_categories()
	_update_values()
	_update_texts()


func _update_categories():
	_categs.clear()
	
	for card in _cards:
		for categ in card.data().categories():
			if _categs.has(categ):
				_categs[categ]["count"] += 1
			else:
				_categs[categ] = {
					"name": card.data().get_category(categ),
					"count": 1,
				}


func _update_values():
	_values.clear()
	
	for card in _cards:
		for value in card.data().values():
			if not _values.has(value):
				_values.append(value)


func _update_texts():
	_texts.clear()
	
	for card in _cards:
		for text in card.data().texts():
			if not _texts.has(text):
				_texts.append(text)

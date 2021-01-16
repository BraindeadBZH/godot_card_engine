class_name AbstractStore
extends Reference
# Base class for in-memory card handling


class StoreSorter:
	var _info: Dictionary = {}

	func _init(sort_info: Dictionary) -> void:
		_info = sort_info

	func sort(left: CardInstance, right: CardInstance) -> bool:
		return _recurive_sort(left.data(), right.data())


	func _recurive_sort(ldata: CardData, rdata: CardData, depth: int = 0) -> bool:
		if depth >= _info.size():
			return false

		var key = _info.keys()[depth]
		var split: Array = key.split(":", false)

		if split[0] == "category":
			var order: Array = _info[key]
			var lval = ldata.get_category(split[1])
			var rval = rdata.get_category(split[1])
			var lidx: int = -1
			var ridx: int = -1
			var idx: int = 0

			for categ in order:
				if categ == lval:
					lidx = idx
				if categ == rval:
					ridx = idx
				idx += 1

			if lidx == ridx:
				return _recurive_sort(ldata, rdata, depth+1)
			elif lidx < ridx:
				return true
		else:
			var asc: bool = _info[key]

			if split[0] == "meta" && split[1] == "id":
				if ldata.id.casecmp_to(rdata.id) == 0:
					return _recurive_sort(ldata, rdata, depth+1)
				elif asc and ldata.id.casecmp_to(rdata.id) == -1:
					return true
				elif not asc and ldata.id.casecmp_to(rdata.id) == 1:
					return true

			elif split[0] == "value":
				if ldata.get_value(split[1]) == rdata.get_value(split[1]):
					return _recurive_sort(ldata, rdata, depth+1)
				elif asc and ldata.get_value(split[1]) < rdata.get_value(split[1]):
					return true
				elif not asc and ldata.get_value(split[1]) > rdata.get_value(split[1]):
					return true

			elif split[0] == "text":
				if ldata.get_text(split[1]).casecmp_to(rdata.get_text(split[1])) == 0:
					return _recurive_sort(ldata, rdata, depth+1)
				elif asc and ldata.get_text(split[1]).casecmp_to(rdata.get_text(split[1])) == -1:
					return true
				elif not asc and ldata.get_text(split[1]).casecmp_to(rdata.get_text(split[1])) == 1:
					return true

		return false


signal changed()
signal card_added()
signal cards_added()
signal card_removed(index)
signal cards_removed()
signal filtered()
signal sorted()
signal cleared()

var save_id: String = ""
var save_name: String = ""

var _cards: Array = []
var _filtered: Array = []
var _cards_count: Dictionary = {}
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
	_cards_count.clear()
	_categs.clear()
	_values.clear()
	_texts.clear()
	_filter = null
	emit_signal("cleared")
	emit_signal("changed")


func populate(db: CardDatabase, ids: Array) -> void:
	clear()

	for id in ids:
		add_card(CardInstance.new(db.get_card(id)))


func populate_all(db: CardDatabase):
	populate(db, db.cards().keys())


func apply_filter(filter: Query) -> void:
	_filter = filter
	_update_filtered()
	emit_signal("filtered")
	emit_signal("changed")


func sort(sort_info: Dictionary) -> void:
	var sorter = StoreSorter.new(sort_info)
	if _filter == null:
		_cards.sort_custom(sorter, "sort")
	else:
		_filtered.sort_custom(sorter, "sort")
	emit_signal("sorted")
	emit_signal("changed")


func count() -> int:
	if _filter == null:
		return _cards.size()
	else:
		return _filtered.size()


func cards_count() -> Dictionary:
	return _cards_count


func count_for(id: String) -> int:
	if _cards_count.has(id):
		return _cards_count[id]
	else:
		return 0


func is_empty() -> bool:
	if _filter == null:
		return _cards.empty()
	else:
		return _filtered.empty()


func has_card(ref: int) -> bool:
	var c = _cards
	if _filter != null:
		c = _filtered

	for card in c:
		if card.ref() == ref:
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


func find(id: String) -> Array:
	var result := []

	for card in _cards:
		if card.data().id == id:
			result.append(card)

	return result


func find_first(id: String) -> CardInstance:
	for card in _cards:
		if card.data().id == id:
			return card

	return null


func find_last(id: String) -> CardInstance:
	var result: CardInstance = null

	for card in _cards:
		if card.data().id == id:
			result = card

	return result


func categories() -> Dictionary:
	return _categs


func get_meta_category(meta: String) -> Dictionary:
	if not _categs.has(meta):
		return {}

	return _categs[meta]


func values() -> Array:
	return _values


func texts() -> Array:
	return _texts


func add_cards(cards: Array) -> void:
	for card in cards:
		_cards.append(card)
	_update_stats()
	_update_filtered()
	emit_signal("cards_added")
	emit_signal("changed")


func add_card(card: CardInstance) -> void:
	_cards.append(card)
	_update_stats()
	_update_filtered()
	emit_signal("card_added")
	emit_signal("changed")


func remove_card(ref: int) -> void:
	var index: int = _ref2idx(ref)

	if index >= 0:
		_cards.remove(index)
		_update_stats()
		_update_filtered()
		emit_signal("card_removed", index)
		emit_signal("changed")


func remove_first(id: String = "") -> void:
	if id == "":
		_cards.pop_front()
	else:
		var card = find_first(id)
		if card == null:
			return

		remove_card(card.ref())

	_update_stats()
	_update_filtered()
	emit_signal("card_removed", 0)
	emit_signal("changed")


func remove_last(id: String = "") -> void:
	if id == "":
		_cards.pop_back()
	else:
		var card = find_last(id)
		if card == null:
			return

		remove_card(card.ref())

	_update_stats()
	_update_filtered()
	emit_signal("card_removed", count()-1)
	emit_signal("changed")


func move_cards(to: AbstractStore) -> void:
	to.add_cards(cards())
	clear()


func move_card(ref: int, to: AbstractStore) -> CardInstance:
	var index: int = _ref2idx(ref)

	if index >= 0:
		var card = _cards[index]
		to.add_card(card)
		_cards.remove(index)
		_update_stats()
		_update_filtered()
		emit_signal("card_removed", index)
		emit_signal("changed")
		return card

	return null


func move_random_card(to: AbstractStore) -> CardInstance:
	return move_card(_rng.random_range(0, count()-1), to)


func copy_cards(to: AbstractStore) -> void:
	for card in _cards:
		to.add_card(CardInstance.new(card.data().duplicate()))


func copy_card(ref: int, to: AbstractStore) -> CardInstance:
	var index: int = _ref2idx(ref)

	if index >= 0:
		var card = _cards[index]
		to.add_card(CardInstance.new(card.data().duplicate()))
		return card

	return null


func copy_random_card(to: AbstractStore) -> CardInstance:
	return copy_card(_rng.random_range(0, _cards.size()-1), to)


func rng() -> PseudoRng:
	return _rng


func keep(count: int) -> void:
	if count > _cards.size():
		return
	_cards.resize(count)
	_update_stats()
	_update_filtered()
	emit_signal("cards_removed")
	emit_signal("changed")


func _ref2idx(ref: int) -> int:
	var search: int = 0

	for card in _cards:
		if card.ref() == ref:
			return search

		search += 1

	return -1


func _update_filtered() -> void:
	_filtered.clear()

	if _filter == null:
		_filtered = _cards.duplicate()
	else:
		for card in _cards:
			if _filter.match_card(card.data()):
				_filtered.append(card)


func _update_stats() -> void:
	_update_count()
	_update_categories()
	_update_values()
	_update_texts()


func _update_count() -> void:
	_cards_count.clear()

	for card in _cards:
		var id = card.data().id
		if _cards_count.has(id):
			_cards_count[id] += 1
		else:
			_cards_count[id] = 1


func _update_categories() -> void:
	_categs.clear()

	for card in _cards:
		for meta in card.data().categories():
			var val = card.data().get_category(meta)
			if _categs.has(meta):
				_categs[meta]["count"] += 1
				if _categs[meta]["values"].has(val):
					_categs[meta]["values"][val] += 1
				else:
					_categs[meta]["values"][val] = 1
			else:
				_categs[meta] = {
					"values": {val: 1},
					"count": 1,
				}


func _update_values() -> void:
	_values.clear()

	for card in _cards:
		for value in card.data().values():
			if not _values.has(value):
				_values.append(value)


func _update_texts() -> void:
	_texts.clear()

	for card in _cards:
		for text in card.data().texts():
			if not _texts.has(text):
				_texts.append(text)

tool
extends Reference
class_name CardDatabase

var id    : String = ""
var name  : String = ""

var _cards: Dictionary = {}

func _init(id: String, name: String):
	self.id     = id
	self.name   = name

func cards() -> Dictionary:
	return _cards

func add_card(card: CardData) -> void:
	_cards[card.id] = card

func card_exists(id: String) -> bool:
	return _cards.has(id)

func get_card(id: String) -> CardData:
	if _cards.has(id):
		return _cards[id]
	else:
		return null

func remove_card(id: String) -> void:
	_cards.erase(id)

func fill_by_categories(store: AbstractStore, filter_categories: Array, or_op: bool = false) -> void:
	for id in _cards:
		var card = _cards[id]
		var card_categories = card.categories()
		var add = false
		
		for filter in filter_categories:
			if filter.empty(): continue
			var include = true
			if filter.begin_with("-"): include = true
			
			if card_categories.has(filter):
				if or_op:
					add |= include
				else:
					add &= include
			
		if add: store.add_card(_cards[id].duplicate())

func fill_by_ids(store: AbstractStore, filter_ids: Array, inversed: bool = false) -> void:
	for id in _cards:
		if inversed && !filter_ids.has(id):
			store.add_card(_cards[id].duplicate())
		if !inversed && filter_ids.has(id):
			store.add_card(_cards[id].duplicate())

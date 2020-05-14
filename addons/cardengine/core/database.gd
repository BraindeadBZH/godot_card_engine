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

func fill_by_categories(store: AbstractStore, filter_categories: Array, inversed: bool = false) -> void:
	for id in _cards:
		var card = _cards[id]
		for categ in card.categories():
			if inversed && !filter_categories.has(categ):
				store.add_card(_cards[id].duplicate())
				return
			if !inversed && filter_categories.has(categ):
				store.add_card(_cards[id].duplicate())
				return

func fill_by_ids(store: AbstractStore, filter_ids: Array, inversed: bool = false) -> void:
	for id in _cards:
		if inversed && !filter_ids.has(id):
			store.add_card(_cards[id].duplicate())
			return
		if !inversed && filter_ids.has(id):
			store.add_card(_cards[id].duplicate())
			return

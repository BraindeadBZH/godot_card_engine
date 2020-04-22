tool
extends Reference
class_name CardDatabase

var id  : String = ""
var name: String = ""
var path: String = ""

var _cards: Dictionary = {}

func _init(id: String, name: String, path: String):
	self.id   = id
	self.name = name
	self.path = path

func cards() -> Dictionary:
	return _cards

func add_card(card: CardData) -> void:
	_cards[card.id] = card

func get_card(id: String) -> CardData:
	return _cards[id]

func remove_card(id: String) -> void:
	_cards.erase(id)

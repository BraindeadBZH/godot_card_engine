tool
class_name CardDatabase
extends Reference

var id: String = ""
var name: String = ""

var _cards: Dictionary = {}


func _init(id: String, name: String) -> void:
	self.id = id
	self.name = name


func count() -> int:
	return _cards.size()


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

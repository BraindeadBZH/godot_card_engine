class_name CardInstance
extends Reference
# Class for managing an instance of a card

var _data: CardData = null
var _mods: Array = [] # TODO: add modifiers support


func _init(data: CardData) -> void:
	_data = data.duplicate()


func ref() -> int:
	return get_instance_id()


func data() -> CardData:
	return _data

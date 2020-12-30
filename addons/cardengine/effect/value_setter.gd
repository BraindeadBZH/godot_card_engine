class_name ValueSetter
extends AbstractModifier

var value_id: String = ""
var value: int = 0

func _init(id: String, stackable: bool, value_id: String, value: int).(id, stackable) -> void:
	self.value_id = value_id
	self.value = value


func modify(card: CardData) -> void:
	if card.has_value(value_id):
		card.set_value(value_id, value)

class_name ValueMultiplier
extends AbstractModifier

var value_id: String = ""
var multiplier: float = 0.0

func _init(id: String, stackable: bool, value_id: String, multiplier: float).(id, stackable) -> void:
	self.value_id = value_id
	self.multiplier = multiplier


func modify(card: CardData) -> void:
	if card.has_value(value_id):
		var val = card.get_value(value_id)
		card.set_value(value_id, floor(val*multiplier))

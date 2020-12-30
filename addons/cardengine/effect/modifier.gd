class_name AbstractModifier
extends Reference

var _fx_ref: int = 0

var id: String = ""
var stackable: bool = false


func _init(id: String, stackable: bool) -> void:
	self.id = id
	self.stackable = stackable


func set_effect_ref(fx: int) -> void:
	_fx_ref = fx


func effect_ref() -> int:
	return _fx_ref


# To override
func modify(card: CardData) -> void:
	pass

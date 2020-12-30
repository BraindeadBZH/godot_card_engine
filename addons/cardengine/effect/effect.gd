tool
class_name AbstractEffect
extends Reference

var id: String = ""
var name: String = ""

func _init(id: String, name: String) -> void:
	self.id = id
	self.name = name


func get_filter() -> Query:
	return null


func get_modifiers() -> Array:
	return []

@tool
class_name AbstractEffect
extends RefCounted

var id: String = ""
var name: String = ""

func _init(id: String, name: String):
	self.id = id
	self.name = name


func get_filter() -> Query:
	return null


func get_modifiers() -> Array[AbstractModifier]:
	return []

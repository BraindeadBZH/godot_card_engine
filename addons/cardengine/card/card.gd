tool
class_name CardData
extends Reference

signal changed()

var id: String = ""

var _categs : Dictionary = {}
var _values: Dictionary = {}
var _texts : Dictionary = {}


func _init(id: String):
	self.id = id


func duplicate() -> CardData:
	var copy = get_script().new(id)
	copy._categs  = _categs.duplicate()
	copy._values = _values.duplicate()
	copy._texts  = _texts.duplicate()
	return copy


func categories() -> Dictionary:
	return _categs


func set_categories(categories: Dictionary) -> void:
	_categs = categories
	mark_changed()


func add_category(id: String, name: String) -> void:
	_categs[id] = name
	mark_changed()


func has_category(id: String) -> bool:
	return _categs.has(id)


func match_category(id: String) -> bool:
	for categ in _categs:
		if categ.match(id):
			return true
	return false


func get_category(id: String) -> String:
	return _categs[id]


func remove_category(id: String) -> void:
	_categs.erase(id)
	mark_changed()


func values() -> Dictionary:
	return _values


func set_values(values: Dictionary) -> void:
	_values = values
	mark_changed()


func add_value(id: String, value: int) -> void:
	_values[id] = value
	mark_changed()


func has_value(id: String) -> bool:
	return _values.has(id)


func get_value(id: String) -> int:
	return _values[id]


func remove_value(id: String) -> void:
	_values.erase(id)
	mark_changed()


func texts() -> Dictionary:
	return _texts


func set_texts(texts: Dictionary) -> void:
	_texts = texts
	mark_changed()


func add_text(id: String, text: String) -> void:
	_texts[id] = text
	mark_changed()


func has_text(id: String) -> bool:
	return _texts.has(id)


func get_text(id: String) -> String:
	return _texts[id]


func remove_text(id: String) -> void:
	_texts.erase(id)
	mark_changed()


func mark_changed():
	emit_signal("changed")

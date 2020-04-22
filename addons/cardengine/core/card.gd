tool
extends Reference
class_name CardData

var id: String = ""

var _categ : Dictionary = {}
var _values: Dictionary = {}
var _texts : Dictionary = {}

func _init(id: String):
	self.id = id

func categories() -> Dictionary:
	return _categ

func set_categories(categories: Dictionary) -> void:
	_categ = categories

func add_category(id: String, name: String) -> void:
	_categ[id] = name

func get_category(id: String) -> String:
	return _categ[id]

func remove_category(id: String) -> void:
	_categ.erase(id)

func values() -> Dictionary:
	return _values

func set_values(values: Dictionary) -> void:
	_values = values()

func add_values(id: String, value: float) -> void:
	_values[id] = value

func get_values(id: String) -> float:
	return _values[id]

func remove_values(id: String) -> void:
	_values.erase(id)

func texts() -> Dictionary:
	return _texts

func set_texts(texts: Dictionary) -> void:
	_texts = texts

func add_text(id: String, text: String) -> void:
	_texts[id] = text

func get_text(id: String) -> String:
	return _texts[id]

func remove_text(id: String) -> void:
	_texts.erase(id)

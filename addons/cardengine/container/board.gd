class_name Board
extends AbstractBoard

var _register: Dictionary = {}


func _ready() -> void:
	_check_for_containers()


func register_last_known_transform(ref: int, trans: CardTransform) -> void:
	_register[ref] = trans


func get_last_known_transform(ref: int) -> CardTransform:
	if not _register.has(ref):
		return null
	else:
		return _register[ref]


func _check_for_containers() -> void:
	for child in get_children():
		if child is AbstractContainer:
			child.set_board(self)

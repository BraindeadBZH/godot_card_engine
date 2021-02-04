class_name DropArea
extends Control

signal dropped(card, source, on_card)

export(Array) var source_filter: Array = []

var _enabled: bool = true
var _filter: Query = null

onready var _manager: GeneralManager = CardEngine.general()


func set_enabled(state: bool) -> void:
	_enabled = state


func set_source_filter(filter: Array) -> void:
	source_filter = filter


func set_filter(filter: Query) -> void:
	_filter = filter


func can_drop_data(_position: Vector2, data) -> bool:
	if not _enabled:
		return false

	if data == "card_engine:drag":
		var source := _manager.get_drag_source()
		if not source_filter.empty() and not source_filter.has(source):
			return false

		if _filter != null:
			var card := _manager.get_dragged_card()
			return _filter.match_card(card.data())
		else:
			return true

	return false


func drop_data(_position: Vector2, data) -> void:
	if not _enabled:
		return

	if data == "card_engine:drag":
		emit_signal("dropped",
			_manager.get_dragged_card(),
			_manager.get_drag_source(),
			_manager.get_drop_on())

		_manager.stop_drag()

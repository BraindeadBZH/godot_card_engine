class_name DropArea
extends Control

signal dropped(card)

export(Array) var source_filter: Array = []

var _enabled: bool = true
var _filter: Query = null


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
		var source = CardEngine.general().get_drag_source()
		if not source_filter.empty() and not source_filter.has(source):
			return false

		if _filter != null:
			var card := CardEngine.general().get_dragged_card()
			return _filter.match_card(card.data())
		else:
			return true

	return false


func drop_data(position: Vector2, data) -> void:
	if not _enabled:
		return

	if data == "card_engine:drag":
		emit_signal("dropped", CardEngine.general().get_dragged_card())
		CardEngine.general().stop_drag()

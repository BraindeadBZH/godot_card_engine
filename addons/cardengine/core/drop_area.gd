class_name DropArea
extends Control

signal dropped(card)

var _filter: Query = null


func set_filter(filter: Query) -> void:
	_filter = filter


func can_drop_data(_position: Vector2, data) -> bool:
	if data == "card_engine:drag":
		if _filter != null:
			var card := CardEngine.general().get_dragged_card()
			return _filter.match_card(card.data())
		else:
			return true

	return false


func drop_data(position: Vector2, data) -> void:
	if data == "card_engine:drag":
		emit_signal("dropped", CardEngine.general().get_dragged_card())
		CardEngine.general().stop_drag()

class_name DropArea
extends Control

signal dropped(card)


func can_drop_data(_position: Vector2, data) -> bool:
	if data == "card_engine:drag":
		return true
	
	return false


func drop_data(position: Vector2, data) -> void:
	if data == "card_engine:drag":
		emit_signal("dropped", CardEngine.general().get_dragged_card())
		CardEngine.general().stop_drag()

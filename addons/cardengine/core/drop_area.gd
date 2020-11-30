class_name DropArea
extends Control

func can_drop_data(_position: Vector2, data) -> bool:
	if data == "card_engine:drag":
		return true
	
	return false


func drop_data(position: Vector2, data) -> void:
	if data == "card_engine:drag":
		print("Dropped")
		# TODO

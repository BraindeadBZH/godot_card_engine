extends Control

onready var _name = $Background/Name


func _ready() -> void:
	CardEngine.general().connect("drag_started", self, "_on_drag_started")


func _on_drag_started():
	var card = CardEngine.general().get_dragged_card()
	
	_name.text = card.data().get_text("name")

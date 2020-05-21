tool
extends TextureButton

export(String) var button_text = "BUTTON" setget set_button_text

onready var _text = $Text


func _ready():
	_text.text = button_text # Compensate for not being able to set the value before in the tree


func set_button_text(new_text: String) -> void:
	button_text = new_text
	if !is_inside_tree():
		return # Avoid crash when value is set before the node is added to the tree
	_text.text = new_text

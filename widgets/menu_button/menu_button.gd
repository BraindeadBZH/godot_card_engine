@tool
extends TextureButton

@export var button_text = "BUTTON":
	set(new_text):
		button_text = new_text
		if !is_inside_tree():
			return # Avoid crash when value is set before the node is added to the tree
		_text.text = new_text


@onready var _text = $Text


func _ready():
	_text.text = button_text # Compensate for not being able to set the value before in the tree

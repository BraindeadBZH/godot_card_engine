tool
extends TextureButton

export(Texture) var button_icon = null setget set_button_icon

func _ready():
	$icon.texture = button_icon

func set_button_icon(new_icon):
	button_icon = new_icon
	if !is_inside_tree(): return
	$icon.texture = new_icon

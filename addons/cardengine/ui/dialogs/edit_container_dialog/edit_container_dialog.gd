tool
extends WindowDialog

onready var _grid_mode = $MainTabs/Layout/LayoutLayout/ModeLayout/GridMode
onready var _path_mode = $MainTabs/Layout/LayoutLayout/ModeLayout/PathMode


func _ready():
	_grid_mode.visible = true
	_path_mode.visible = false


func set_container(id: String) -> void:
	pass # TODO


func _on_ModeSwitch_toggled(button_pressed):
	if button_pressed:
		_grid_mode.visible = false
		_path_mode.visible = true
	else:
		_grid_mode.visible = true
		_path_mode.visible = false

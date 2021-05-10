tool
extends EditorPlugin

var _main_scene: PackedScene = preload("ui/card_engine_ui.tscn")
var _main_control: CardEngineUI = null


func _enter_tree():
	_main_control = _main_scene.instance()
	add_control_to_bottom_panel(_main_control, "CardEngine")
	CardEngine.setup(self)


func _exit_tree():
	remove_control_from_bottom_panel(_main_control)

	if _main_control != null:
		_main_control.queue_free()
		_main_control = null

	CardEngine.clean()

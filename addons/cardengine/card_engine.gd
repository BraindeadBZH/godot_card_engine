tool
extends EditorPlugin

var _main_scene: PackedScene = preload("ui/card_engine_ui.tscn")
var _main_control: CardEngineUI = null
var _tool_btn: Button = null


func _enter_tree():
	_main_control = _main_scene.instance()
	_tool_btn = add_control_to_bottom_panel(_main_control, "CardEngine")
	CardEngine.setup(self)


func _exit_tree():
	remove_control_from_bottom_panel(_main_control)

	if _tool_btn != null:
		_tool_btn.queue_free()
		_tool_btn = null

	if _main_control != null:
		_main_control.queue_free()
		_main_control = null

	CardEngine.clean()

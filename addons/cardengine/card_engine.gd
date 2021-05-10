tool
extends EditorPlugin

var _main_scene: PackedScene = preload("ui/card_engine_ui.tscn")
var _main_control: CardEngineUI = null


func _enter_tree():
	_main_control = _main_scene.instance()
	add_control_to_bottom_panel(_main_control, "CardEngine")
	CardEngine.setup()

	CardEngine.general().connect("filesystem_changed", self, "scan_for_new_files")
	CardEngine.db().connect("filesystem_changed", self, "scan_for_new_files")
	CardEngine.cont().connect("filesystem_changed", self, "scan_for_new_files")
	CardEngine.anim().connect("filesystem_changed", self, "scan_for_new_files")
	CardEngine.fx().connect("filesystem_changed", self, "scan_for_new_files")

	CardEngine.general().connect("request_edit", self, "open_for_edit")
	CardEngine.db().connect("request_edit", self, "open_for_edit")
	CardEngine.cont().connect("request_edit", self, "open_for_edit")
	CardEngine.anim().connect("request_edit", self, "open_for_edit")
	CardEngine.fx().connect("request_edit", self, "open_for_edit")

	CardEngine.general().connect("request_scene", self, "open_scene")
	CardEngine.db().connect("request_scene", self, "open_scene")
	CardEngine.cont().connect("request_scene", self, "open_scene")
	CardEngine.anim().connect("request_scene", self, "open_scene")
	CardEngine.fx().connect("request_scene", self, "open_scene")


func _exit_tree():
	remove_control_from_bottom_panel(_main_control)

	if _main_control != null:
		_main_control.queue_free()
		_main_control = null

	CardEngine.clean()


func scan_for_new_files() -> void:
	get_editor_interface().get_resource_filesystem().scan()


func open_for_edit(res: Resource) -> void:
	get_editor_interface().edit_resource(res)


func open_scene(path: String) -> void:
	get_editor_interface().open_scene_from_path(path)

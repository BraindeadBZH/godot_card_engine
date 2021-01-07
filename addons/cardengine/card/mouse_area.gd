extends TextureButton

signal drag_started()

var _drag_enabled: bool = true
var _drag_widget: PackedScene = null


func set_drag_enabled(state: bool) -> void:
	_drag_enabled = state


func set_drag_widget(scene: PackedScene) -> void:
	_drag_widget = scene


func get_drag_data(_position: Vector2):
	if not _drag_enabled:
		return null

	if _drag_widget != null:
		set_drag_preview(_drag_widget.instance())

	emit_signal("drag_started")

	return "card_engine:drag"

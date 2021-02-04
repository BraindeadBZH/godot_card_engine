extends TextureButton

signal drag_started()
signal prepare_for_drop()

var _drag_enabled: bool = true
var _drag_widget: PackedScene = null
var _drop_area: DropArea = null


func set_drag_enabled(state: bool) -> void:
	_drag_enabled = state


func set_drag_widget(scene: PackedScene) -> void:
	_drag_widget = scene


func set_drop_area(area: DropArea) -> void:
	_drop_area = area


func get_drag_data(_position: Vector2):
	if not _drag_enabled:
		return null

	if _drag_widget != null:
		set_drag_preview(_drag_widget.instance())

	emit_signal("drag_started")

	return "card_engine:drag"


func can_drop_data(position: Vector2, data) -> bool:
	if _drop_area != null:
		var can_drop = _drop_area.can_drop_data(position, data)

		if can_drop:
			emit_signal("prepare_for_drop")

		return can_drop

	return false


func drop_data(position: Vector2, data) -> void:
	if _drop_area != null:
		_drop_area.drop_data(position, data)

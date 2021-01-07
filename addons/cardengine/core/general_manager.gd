tool
class_name GeneralManager
extends AbstractManager

signal drag_started()
signal drag_stopped()

var _drag_started: bool = false
var _dragged_card: CardInstance = null


func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []

	if form_name == "generic_confirm":
		if !form["confirm"]:
			errors.append("Please confirm first")

	return errors


func start_drag(card: CardInstance) -> void:
	_drag_started = true
	_dragged_card = card
	emit_signal("drag_started")


func is_dragging() -> bool:
	return _drag_started


func get_dragged_card() -> CardInstance:
	return _dragged_card


func stop_drag() -> void:
	_drag_started = false
	_dragged_card = null
	emit_signal("drag_stopped")

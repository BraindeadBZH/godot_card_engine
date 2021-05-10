tool
class_name AbstractManager
extends Node

signal filesystem_changed()
signal request_edit(resource)
signal request_scene(path)


func clean() -> void:
	pass


func validate_form(form_name: String, form: Dictionary) -> Array:
	return []

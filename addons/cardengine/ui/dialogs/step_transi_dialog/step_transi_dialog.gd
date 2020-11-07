tool
extends AbstractFormDialog

var _seq: String = ""
var _index: int = -1

onready var _duration = $MainLayout/Form/Duration
onready var _type = $MainLayout/Form/Type
onready var _easing = $MainLayout/Form/Easing


func _ready():
	setup("step_transi", CardEngine.anim())


func _reset_form() -> void:
	_duration.value = 0
	_type.select(0)
	_easing.select(0)


func _extract_form() -> Dictionary:
	return {
		"seq": _seq,
		"index": _index,
		"duration": _duration.value / 1000.0,
		"type": _type.selected,
		"easing": _easing.selected
	}


func _fill_form(data: Dictionary) -> void:
	_seq = data["seq"]
	_index = data["index"]
	_duration.value = data["duration"] * 1000.0
	_type.select(data["type"])
	_easing.select(data["easing"])

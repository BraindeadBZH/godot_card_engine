tool
extends AbstractFormDialog

var _seq: AnimationSequence = null
var _index: int = -1

onready var _random = $MainLayout/Form/Random
onready var _duration = $MainLayout/Form/Duration
onready var _duration_lbl = $MainLayout/Form/DurationLbl
onready var _duration_range_min = $MainLayout/Form/DurationRangeLayout/DurationRangeMin
onready var _duration_range_max = $MainLayout/Form/DurationRangeLayout/DurationRangeMax
onready var _duration_range_lbl = $MainLayout/Form/DurationRangeLbl
onready var _duration_range_layout = $MainLayout/Form/DurationRangeLayout
onready var _type = $MainLayout/Form/Type
onready var _easing = $MainLayout/Form/Easing
onready var _flip_card = $MainLayout/Form/FlipCard
onready var _inter = $MainLayout/Form/Interactive


func _ready():
	setup("step_transi", CardEngine.anim())


func _reset_form() -> void:
	_random.pressed = false
	_duration.value = 0
	_duration_range_min.value = 0
	_duration_range_max.value = 0
	_type.select(0)
	_easing.select(0)
	_flip_card.pressed = false
	_inter.pressed = false
	_update_layout()


func _extract_form() -> Dictionary:
	return {
		"seq": _seq,
		"index": _index,
		"random_duration": _random.pressed,
		"duration": _duration.value / 1000.0,
		"duration_range_min": _duration_range_min.value / 1000.0,
		"duration_range_max": _duration_range_max.value / 1000.0,
		"type": _type.selected,
		"easing": _easing.selected,
		"flip_card": _flip_card.pressed,
		"interactive": _inter.pressed
	}


func _fill_form(data: Dictionary) -> void:
	_seq = data["seq"]
	_index = data["index"]
	_random.pressed = data["random_duration"]
	_duration.value = data["duration"] * 1000.0
	_duration_range_min.value = data["duration_range_min"] * 1000.0
	_duration_range_max.value = data["duration_range_max"] * 1000.0
	_type.select(data["type"])
	_easing.select(data["easing"])
	_flip_card.pressed = data["flip_card"]
	_inter.pressed = data["interactive"]
	_update_layout()


func _update_layout() -> void:
	_duration.visible = not _random.pressed
	_duration_lbl.visible = not _random.pressed
	_duration_range_lbl.visible = _random.pressed
	_duration_range_layout.visible = _random.pressed


func _on_Random_pressed() -> void:
	_update_layout()

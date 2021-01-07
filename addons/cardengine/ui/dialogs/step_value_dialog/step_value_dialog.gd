tool
extends AbstractFormDialog

var _seq: AnimationSequence = null
var _index: int = -1

onready var _mode = $MainLayout/Form/Mode
onready var _num_val_lbl = $MainLayout/Form/NumValueLbl
onready var _num_val = $MainLayout/Form/NumValue
onready var _vec_val_lbl = $MainLayout/Form/VecValueLbl
onready var _vec_val_x = $MainLayout/Form/VecValueLayout/VecValueX
onready var _vec_val_y = $MainLayout/Form/VecValueLayout/VecValueY
onready var _num_range_lbl = $MainLayout/Form/NumRangeLbl
onready var _num_range = $MainLayout/Form/NumRange
onready var _vec_range_lbl = $MainLayout/Form/VecRangeLbl
onready var _vec_range_x = $MainLayout/Form/VecRangeLayout/VecRangeX
onready var _vec_range_y = $MainLayout/Form/VecRangeLayout/VecRangeY


func _ready():
	setup("step_value", CardEngine.anim())


func _reset_form() -> void:
	_mode.select(0)
	_num_val.value = 0
	_vec_val_x.value = 0
	_vec_val_y.value = 0
	_num_range.value = 0
	_vec_range_x.value = 0
	_vec_range_y.value = 0


func _extract_form() -> Dictionary:
	if _seq is RotationSequence:
		return {
				"seq": _seq,
				"index": _index,
				"mode": _mode.selected,
				"value": _num_val.value,
				"range": _num_range.value
			}
	else:
		return {
				"seq": _seq,
				"index": _index,
				"mode": _mode.selected,
				"value": Vector2(_vec_val_x.value, _vec_val_y.value),
				"range": Vector2(_vec_range_x.value, _vec_range_y.value)
			}


func _fill_form(data: Dictionary) -> void:
	_seq = data["seq"]
	_index = data["index"]

	if _seq is RotationSequence:
		_mode.select(data["mode"])
		_num_val.value = data["value"]
		_num_range.value = data["range"]
	else:
		_mode.select(data["mode"])
		_vec_val_x.value = data["value"].x
		_vec_val_y.value = data["value"].y
		_vec_range_x.value = data["range"].x
		_vec_range_y.value = data["range"].y

	_config_ui()


func _config_ui() -> void:
	if _seq is RotationSequence:
		_vec_val_lbl.visible = false
		_vec_val_x.visible = false
		_vec_val_y.visible = false
		_vec_range_lbl.visible = false
		_vec_range_x.visible = false
		_vec_range_y.visible = false

		_num_val_lbl.visible = _mode.selected > 0
		_num_val.visible = _mode.selected > 0
		_num_range_lbl.visible = _mode.selected == 2
		_num_range.visible = _mode.selected == 2
	else:
		_num_val_lbl.visible = false
		_num_val.visible = false
		_num_range_lbl.visible = false
		_num_range.visible = false

		_vec_val_lbl.visible = _mode.selected > 0
		_vec_val_x.visible = _mode.selected > 0
		_vec_val_y.visible = _mode.selected > 0
		_vec_range_lbl.visible = _mode.selected == 2
		_vec_range_x.visible = _mode.selected == 2
		_vec_range_y.visible = _mode.selected == 2


func _on_Mode_item_selected(_index: int) -> void:
	_config_ui()

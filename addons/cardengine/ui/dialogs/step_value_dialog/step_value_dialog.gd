tool
extends AbstractFormDialog

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

var is_vec: bool = false


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
	
	if is_vec:
		_num_val_lbl.visible = false
		_num_val.visible = false
		_num_range_lbl.visible = false
		_num_range.visible = false
		
		_vec_val_lbl.visible = true
		_vec_val_x.visible = true
		_vec_val_y.visible = true
		_vec_range_lbl.visible = true
		_vec_range_x.visible = true
		_vec_range_y.visible = true
	else:
		_num_val_lbl.visible = true
		_num_val.visible = true
		_num_range_lbl.visible = true
		_num_range.visible = true
		
		_vec_val_lbl.visible = false
		_vec_val_x.visible = false
		_vec_val_y.visible = false
		_vec_range_lbl.visible = false
		_vec_range_x.visible = false
		_vec_range_y.visible = false


func _extract_form() -> Dictionary:
	if is_vec:
		return {
			"mode": _mode.selected,
			"value": Vector2(_vec_val_x.value, _vec_val_y.value),
			"range": Vector2(_vec_range_x.value, _vec_range_y.value)
		}
	else:
		return {
			"mode": _mode.selected,
			"value": _num_val.value,
			"range": _num_range.value
		}


func _fill_form(data: Dictionary) -> void:
	if is_vec:
		_mode.select(data["mode"])
		_vec_val_x.value = data["value"].x
		_vec_val_y.value = data["value"].y
		_vec_range_x.value = data["range"].x
		_vec_range_y.value = data["range"].y
	else:
		_mode.select(data["mode"])
		_num_val.value = data["value"]
		_num_range.value = data["range"]

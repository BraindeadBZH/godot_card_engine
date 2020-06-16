tool
extends WindowDialog

var _data: ContainerData = null

onready var _manager: ContainerManager = CardEngine.cont()
onready var _mode_switch = $MainLayout/MainTabs/Layout/LayoutLayout/ModeSwitchLayout/ModeSwitch
onready var _face_switch = $MainLayout/MainTabs/Layout/LayoutLayout/FaceSwitchLayout/FaceSwitch
onready var _grid_mode = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode
onready var _path_mode = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/PathMode
onready var _grid_width = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridCardWidth
onready var _grid_fixed = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/FixedWidth
onready var _grid_spacing_h = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridCardSpacingLayout/GridCardSpacingH
onready var _grid_spacing_v = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridCardSpacingLayout/GridCardSpacingV
onready var _grid_align_h = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridAlignH
onready var _grid_align_v = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridAlignV
onready var _grid_columns = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridColumns
onready var _grid_expand = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/GridMode/GridModeLayout/GridExpand
onready var _path_width = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/PathMode/PathModeLayout/PathCardWidth
onready var _path_fixed = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/PathMode/PathModeLayout/PathFixedWidth
onready var _path_spacing = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/PathMode/PathModeLayout/PathSpacing

onready var _pos_enabled = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/Enabled
onready var _pos_mode = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/Mode
onready var _pos_range_min_h = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/RangeMinLayout/RangeH
onready var _pos_range_min_v = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/RangeMinLayout/RangeV
onready var _pos_range_max_h = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/RangeMaxLayout/RangeH
onready var _pos_range_max_v = $MainLayout/MainTabs/FineTuning/TuningLayout/PostionLayout/RangeMaxLayout/RangeV

onready var _angle_enabled = $MainLayout/MainTabs/FineTuning/TuningLayout/AngleLayout/Enabled
onready var _angle_mode = $MainLayout/MainTabs/FineTuning/TuningLayout/AngleLayout/Mode
onready var _angle_range_min = $MainLayout/MainTabs/FineTuning/TuningLayout/AngleLayout/RangeLayout/RangeMin
onready var _angle_range_max = $MainLayout/MainTabs/FineTuning/TuningLayout/AngleLayout/RangeLayout/RangeMax

onready var _scale_enabled = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/Enabled
onready var _scale_mode = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/Mode
onready var _scale_ratio = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/Ratio
onready var _scale_range_min_h = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/RangeMinLayout/RangeH
onready var _scale_range_min_v = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/RangeMinLayout/RangeV
onready var _scale_range_max_h = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/RangeMaxLayout/RangeH
onready var _scale_range_max_v = $MainLayout/MainTabs/FineTuning/TuningLayout/ScaleLayout/RangeMaxLayout/RangeV


func _ready():
	_grid_mode.visible = true
	_path_mode.visible = false


func set_container(id: String) -> void:
	_data = _manager.get_container(id)
	_update()


func _update() -> void:
	if _data == null:
		return
	
	_face_switch.pressed = _data.face_up
	_grid_width.value = _data.grid_card_width
	_grid_fixed.pressed = _data.grid_fixed_width
	_grid_spacing_h.value = _data.grid_card_spacing.x
	_grid_spacing_v.value = _data.grid_card_spacing.y
	_grid_columns.value = _data.grid_columns
	_grid_expand.pressed = _data.grid_expand
	_path_width.value = _data.path_card_width
	_path_fixed.pressed = _data.path_fixed_width
	_path_spacing.value = _data.path_spacing
	
	match _data.mode:
		"grid":
			_mode_switch.pressed = false
		"path":
			_mode_switch.pressed = true
	
	match _data.grid_halign:
		"left":
			_grid_align_h.select(0)
		"center":
			_grid_align_h.select(1)
		"right":
			_grid_align_h.select(2)
	
	match _data.grid_valign:
		"top":
			_grid_align_v.select(0)
		"middle":
			_grid_align_v.select(1)
		"bottom":
			_grid_align_v.select(2)
	
	_pos_enabled.pressed = _data.fine_pos
	_pos_range_min_h.value = _data.fine_pos_min.x
	_pos_range_min_v.value = _data.fine_pos_min.y
	_pos_range_max_h.value = _data.fine_pos_max.x
	_pos_range_max_v.value = _data.fine_pos_max.y
	match _data.fine_pos_mode:
		"linear":
			_pos_mode.select(0)
		"symmetric":
			_pos_mode.select(1)
		"random":
			_pos_mode.select(2)
	
	_angle_enabled.pressed = _data.fine_angle
	_angle_range_min.value = _data.fine_angle_min
	_angle_range_max.value = _data.fine_angle_max
	match _data.fine_angle_mode:
		"linear":
			_angle_mode.select(0)
		"symmetric":
			_angle_mode.select(1)
		"random":
			_angle_mode.select(2)
	
	_scale_enabled.pressed = _data.fine_scale
	_scale_range_min_h.value = _data.fine_scale_min.x
	_scale_range_min_v.value = _data.fine_scale_min.y
	_scale_range_max_h.value = _data.fine_scale_max.x
	_scale_range_max_v.value = _data.fine_scale_max.y
	match _data.fine_scale_mode:
		"linear":
			_scale_mode.select(0)
		"symmetric":
			_scale_mode.select(1)
		"random":
			_scale_mode.select(2)
	match _data.fine_scale_ratio:
		"keep":
			_scale_ratio.select(0)
		"ignore":
			_scale_ratio.select(1)


func _save() -> void:
	if _data == null:
		return
	
	_data.face_up = _face_switch.pressed
	_data.grid_card_width = _grid_width.value
	_data.grid_fixed_width = _grid_fixed.pressed
	_data.grid_card_spacing.x = _grid_spacing_h.value
	_data.grid_card_spacing.y = _grid_spacing_v.value
	_data.grid_columns = _grid_columns.value
	_data.grid_expand = _grid_expand.pressed
	_data.path_card_width = _path_width.value
	_data.path_fixed_width = _path_fixed.pressed
	_data.path_spacing = _path_spacing.value
	
	if _mode_switch.pressed:
		_data.mode = "path"
	else:
		_data.mode = "grid"
	
	match _grid_align_h.selected:
		0:
			_data.grid_halign = "left"
		1:
			_data.grid_halign = "center"
		2:
			_data.grid_halign = "right"
	
	match _grid_align_v.selected:
		0:
			_data.grid_valign = "top"
		1:
			_data.grid_valign = "middle"
		2:
			_data.grid_valign = "bottom"
	
	_data.fine_pos = _pos_enabled.pressed
	_data.fine_pos_min.x = _pos_range_min_h.value
	_data.fine_pos_min.y = _pos_range_min_v.value
	_data.fine_pos_max.x = _pos_range_max_h.value
	_data.fine_pos_max.y = _pos_range_max_v.value
	match _pos_mode.selected:
		0:
			_data.fine_pos_mode = "linear"
		1:
			_data.fine_pos_mode = "symmetric"
		2:
			_data.fine_pos_mode = "random"
	
	_data.fine_angle = _angle_enabled.pressed
	_data.fine_angle_min = _angle_range_min.value
	_data.fine_angle_max = _angle_range_max.value
	match _angle_mode.selected:
		0:
			_data.fine_angle_mode = "linear"
		1:
			_data.fine_angle_mode = "symmetric"
		2:
			_data.fine_angle_mode = "random"
	
	_data.fine_scale = _scale_enabled.pressed
	_data.fine_scale_min.x = _scale_range_min_h.value
	_data.fine_scale_min.y = _scale_range_min_v.value
	_data.fine_scale_max.x = _scale_range_max_h.value
	_data.fine_scale_max.y = _scale_range_max_v.value
	match _scale_mode.selected:
		0:
			_data.fine_scale_mode = "linear"
		1:
			_data.fine_scale_mode = "symmetric"
		2:
			_data.fine_scale_mode = "random"
	match _scale_ratio.selected:
		0:
			_data.fine_scale_ratio = "keep"
		1:
			_data.fine_scale_ratio = "ignore"
	
	_manager.update_container(_data)


func _on_ModeSwitch_toggled(button_pressed):
	if button_pressed:
		_grid_mode.visible = false
		_path_mode.visible = true
	else:
		_grid_mode.visible = true
		_path_mode.visible = false


func _on_SaveBtn_pressed() -> void:
	_save()
	hide()


func _on_CancelBtn_pressed() -> void:
	hide()

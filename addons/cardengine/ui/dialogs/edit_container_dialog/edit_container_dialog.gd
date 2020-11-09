tool
extends WindowDialog

var _data: ContainerData = null

onready var _manager: ContainerManager = CardEngine.cont()
onready var _anims: AnimationManager = CardEngine.anim()
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

onready var _trans_order_duration = $MainLayout/MainTabs/Transitions/TransLayout/OrderLayout/Duration
onready var _trans_order_type = $MainLayout/MainTabs/Transitions/TransLayout/OrderLayout/Type
onready var _trans_order_easing = $MainLayout/MainTabs/Transitions/TransLayout/OrderLayout/Easing

onready var _trans_in_duration = $MainLayout/MainTabs/Transitions/TransLayout/InLayout/Duration
onready var _trans_in_type = $MainLayout/MainTabs/Transitions/TransLayout/InLayout/Type
onready var _trans_in_easing = $MainLayout/MainTabs/Transitions/TransLayout/InLayout/Easing

onready var _trans_out_duration = $MainLayout/MainTabs/Transitions/TransLayout/OutLayout/Duration
onready var _trans_out_type = $MainLayout/MainTabs/Transitions/TransLayout/OutLayout/Type
onready var _trans_out_easing = $MainLayout/MainTabs/Transitions/TransLayout/OutLayout/Easing

onready var _trans_flip_start_duration = $MainLayout/MainTabs/Transitions/TransLayout/FlipStartLayout/Duration
onready var _trans_flip_start_type = $MainLayout/MainTabs/Transitions/TransLayout/FlipStartLayout/Type
onready var _trans_flip_start_easing = $MainLayout/MainTabs/Transitions/TransLayout/FlipStartLayout/Easing

onready var _trans_flip_end_duration = $MainLayout/MainTabs/Transitions/TransLayout/FlipEndLayout/Duration
onready var _trans_flip_end_type = $MainLayout/MainTabs/Transitions/TransLayout/FlipEndLayout/Type
onready var _trans_flip_end_easing = $MainLayout/MainTabs/Transitions/TransLayout/FlipEndLayout/Easing

onready var _interactive = $MainLayout/MainTabs/Animations/AnimLayout/InterLayout/Inter
onready var _idle_anim = $MainLayout/MainTabs/Animations/AnimLayout/IdleLayout/Anim
onready var _idle_anim_repeat = $MainLayout/MainTabs/Animations/AnimLayout/IdleLayout/Loop
onready var _focused_anim = $MainLayout/MainTabs/Animations/AnimLayout/FocusedLayout/Anim
onready var _focused_anim_repeat = $MainLayout/MainTabs/Animations/AnimLayout/FocusedLayout/Loop


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
	
	_mode_switch.pressed = _layout_mode_to_switch(_data.mode)
	
	_grid_align_h.select(_halign_to_select(_data.grid_halign))
	_grid_align_v.select(_valign_to_select(_data.grid_valign))
	
	_pos_enabled.pressed = _data.fine_pos
	_pos_range_min_h.value = _data.fine_pos_min.x
	_pos_range_min_v.value = _data.fine_pos_min.y
	_pos_range_max_h.value = _data.fine_pos_max.x
	_pos_range_max_v.value = _data.fine_pos_max.y
	_pos_mode.select(_finetune_mode_to_select(_data.fine_pos_mode))
	
	_angle_enabled.pressed = _data.fine_angle
	_angle_range_min.value = _data.fine_angle_min
	_angle_range_max.value = _data.fine_angle_max
	_angle_mode.select(_finetune_mode_to_select(_data.fine_angle_mode))
	
	_scale_enabled.pressed = _data.fine_scale
	_scale_range_min_h.value = _data.fine_scale_min.x
	_scale_range_min_v.value = _data.fine_scale_min.y
	_scale_range_max_h.value = _data.fine_scale_max.x
	_scale_range_max_v.value = _data.fine_scale_max.y
	_scale_mode.select(_finetune_mode_to_select(_data.fine_scale_mode))
	_scale_ratio.select(_scale_ratio_to_select(_data.fine_scale_ratio))
	
	_trans_order_duration.value = _data.order_duration * 1000
	_trans_order_type.select(_trans_type_to_select(_data.order_type))
	_trans_order_easing.select(_trans_easing_to_select(_data.order_easing))
	
	_trans_in_duration.value = _data.in_duration * 1000
	_trans_in_type.select(_trans_type_to_select(_data.in_type))
	_trans_in_easing.select(_trans_easing_to_select(_data.in_easing))
	
	_trans_out_duration.value = _data.out_duration * 1000
	_trans_out_type.select(_trans_type_to_select(_data.out_type))
	_trans_out_easing.select(_trans_easing_to_select(_data.out_easing))
	
	_trans_flip_start_duration.value = _data.flip_start_duration * 1000
	_trans_flip_start_type.select(_trans_type_to_select(_data.flip_start_type))
	_trans_flip_start_easing.select(_trans_easing_to_select(_data.flip_start_easing))
	
	_trans_flip_end_duration.value = _data.flip_end_duration * 1000
	_trans_flip_end_type.select(_trans_type_to_select(_data.flip_end_type))
	_trans_flip_end_easing.select(_trans_easing_to_select(_data.flip_end_easing))
	
	_interactive.pressed = _data.interactive
	
	_idle_anim.clear()
	_focused_anim.clear()
	
	_idle_anim.add_item("None")
	_idle_anim.set_item_metadata(0, "none")
	_focused_anim.add_item("None")
	_focused_anim.set_item_metadata(0, "none")
	
	var index = 1
	var select_idle = 0
	var select_focused = 0
	for id in _anims.animations():
		var anim = _anims.get_animation(id)
		_idle_anim.add_item(anim.name)
		_idle_anim.set_item_metadata(index, anim.id)
		_focused_anim.add_item(anim.name)
		_focused_anim.set_item_metadata(index, anim.id)
		
		if _data.idle_anim == anim.id:
			select_idle = index
		if _data.focused_anim == anim.id:
			select_focused = index
		
		index += 1
	
	_idle_anim.select(select_idle)
	_idle_anim_repeat.pressed = _data.idle_anim_repeat
	_focused_anim.select(select_focused)
	_focused_anim_repeat.pressed = _data.focused_anim_repeat


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
	
	_data.mode = _switch_to_layout_mode(_mode_switch.pressed)
	
	_data.grid_halign = _select_to_halign(_grid_align_h.selected)
	_data.grid_valign = _select_to_valign(_grid_align_v.selected)
	
	_data.fine_pos = _pos_enabled.pressed
	_data.fine_pos_min.x = _pos_range_min_h.value
	_data.fine_pos_min.y = _pos_range_min_v.value
	_data.fine_pos_max.x = _pos_range_max_h.value
	_data.fine_pos_max.y = _pos_range_max_v.value
	_data.fine_pos_mode = _select_to_finetune_mode(_pos_mode.selected)
	
	_data.fine_angle = _angle_enabled.pressed
	_data.fine_angle_min = _angle_range_min.value
	_data.fine_angle_max = _angle_range_max.value
	_data.fine_angle_mode = _select_to_finetune_mode(_angle_mode.selected)
	
	_data.fine_scale = _scale_enabled.pressed
	_data.fine_scale_min.x = _scale_range_min_h.value
	_data.fine_scale_min.y = _scale_range_min_v.value
	_data.fine_scale_max.x = _scale_range_max_h.value
	_data.fine_scale_max.y = _scale_range_max_v.value
	_data.fine_scale_mode = _select_to_finetune_mode(_scale_mode.selected)
	_data.fine_scale_ratio = _select_to_scale_ratio(_scale_ratio.selected)
	
	_data.order_duration = _trans_order_duration.value / 1000.0
	_data.order_type = _select_to_trans_type(_trans_order_type.selected)
	_data.order_easing = _select_to_trans_easing(_trans_order_easing.selected)
	
	_data.in_duration = _trans_in_duration.value / 1000.0
	_data.in_type = _select_to_trans_type(_trans_in_type.selected)
	_data.in_easing = _select_to_trans_easing(_trans_in_easing.selected)
	
	_data.out_duration = _trans_out_duration.value / 1000.0
	_data.out_type = _select_to_trans_type(_trans_out_type.selected)
	_data.out_easing = _select_to_trans_easing(_trans_out_easing.selected)
	
	_data.flip_start_duration = _trans_flip_start_duration.value / 1000.0
	_data.flip_start_type = _select_to_trans_type(_trans_flip_start_type.selected)
	_data.flip_start_easing = _select_to_trans_easing(_trans_flip_start_easing.selected)
	
	_data.flip_end_duration = _trans_flip_end_duration.value / 1000.0
	_data.flip_end_type = _select_to_trans_type(_trans_flip_end_type.selected)
	_data.flip_end_easing = _select_to_trans_easing(_trans_flip_end_easing.selected)
	
	_data.interactive = _interactive.pressed
	_data.idle_anim = _idle_anim.get_selected_metadata()
	_data.idle_anim_repeat = _idle_anim_repeat.pressed
	_data.focused_anim = _focused_anim.get_selected_metadata()
	_data.focused_anim_repeat = _focused_anim_repeat.pressed
	
	_manager.update_container(_data)


func _layout_mode_to_switch(mode: String) -> bool:
	match mode:
		"grid":
			return false
		"path":
			return true
		_:
			return false


func _switch_to_layout_mode(switch: bool) -> String:
	if switch:
		return "path"
	else:
		return "grid"


func _halign_to_select(align: String) -> int:
	match align:
		"left":
			return 0
		"center":
			return 1
		"right":
			return 2
		_:
			return 0


func _select_to_halign(select: int) -> String:
	match select:
		0:
			return "left"
		1:
			return "center"
		2:
			return "right"
		_:
			return "left"


func _valign_to_select(align: String) -> int:
	match align:
		"top":
			return 0
		"middle":
			return 1
		"bottom":
			return 2
		_:
			return 0


func _select_to_valign(select: int) -> String:
	match select:
		0:
			return "top"
		1:
			return "middle"
		2:
			return "bottom"
		_:
			return "top"


func _finetune_mode_to_select(mode: String) -> int:
	match mode:
		"linear":
			return 0
		"symmetric":
			return 1
		"random":
			return 2
		_:
			return 0


func _select_to_finetune_mode(select: int) -> String:
	match select:
		0:
			return "linear"
		1:
			return "symmetric"
		2:
			return "random"
		_:
			return "linear"


func _scale_ratio_to_select(ratio: String) -> int:
	match ratio:
		"keep":
			return 0
		"ignore":
			return 1
		_:
			return 0


func _select_to_scale_ratio(select: int) -> String:
	match select:
		0:
			return "keep"
		1:
			return "ignore"
		_:
			return "keep"


func _trans_type_to_select(type: String) -> int:
	match type:
		"linear":
			return 0
		"sine":
			return 1
		"quint":
			return 2
		"quart":
			return 3
		"quad":
			return 4
		"expo":
			return 5
		"elastic":
			return 6
		"cubic":
			return 7
		"circ":
			return 8
		"bounce":
			return 9
		"back":
			return 10
		_:
			return 0


func _select_to_trans_type(select: int) -> String:
	match select:
		0:
			return "linear"
		1:
			return "sine"
		2:
			return "quint"
		3:
			return "quart"
		4:
			return "quad"
		5:
			return "expo"
		6:
			return "elastic"
		7:
			return "cubic"
		8:
			return "circ"
		9:
			return "bounce"
		10:
			return "back"
		_:
			return "linear"


func _trans_easing_to_select(easing: String) -> int:
	match easing:
		"in":
			return 0
		"out":
			return 1
		"in_out":
			return 2
		"out_in":
			return 3
		_:
			return 0


func _select_to_trans_easing(select: int) -> String:
	match select:
		0:
			return "in"
		1:
			return "out"
		2:
			return "in_out"
		3:
			return "out_in"
		_:
			return "in"


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

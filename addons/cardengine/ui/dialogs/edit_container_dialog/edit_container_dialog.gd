tool
extends WindowDialog

var _data: ContainerData = null

onready var _manager: ContainerManager = CardEngine.cont()
onready var _mode_switch = $MainLayout/MainTabs/Layout/LayoutLayout/ModeSwitchLayout/ModeSwitch
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
onready var _path_spacing = $MainLayout/MainTabs/Layout/LayoutLayout/ModeLayout/PathMode/PathModeLayout/PathSpacing


func _ready():
	_grid_mode.visible = true
	_path_mode.visible = false


func set_container(id: String) -> void:
	_data = _manager.get_container(id)
	_update()


func _update() -> void:
	if _data == null:
		return
	
	_grid_width.value = _data.grid_card_width
	_grid_fixed.pressed = _data.grid_fixed_width
	_grid_spacing_h.value = _data.grid_card_spacing.x
	_grid_spacing_v.value = _data.grid_card_spacing.y
	_grid_columns.value = _data.grid_columns
	_grid_expand.pressed = _data.grid_expand
	_path_width.value = _data.path_card_width
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


func _save() -> void:
	if _data == null:
		return
	
	_data.grid_card_width = _grid_width.value
	_data.grid_fixed_width = _grid_fixed.pressed
	_data.grid_card_spacing.x = _grid_spacing_h.value
	_data.grid_card_spacing.y = _grid_spacing_v.value
	_data.grid_columns = _grid_columns.value
	_data.grid_expand = _grid_expand.pressed
	_data.path_card_width = _path_width.value
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
	
	match _grid_align_h.selected:
		0:
			_data.grid_valign = "top"
		1:
			_data.grid_valign = "middle"
		2:
			_data.grid_valign = "bottom"
	
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

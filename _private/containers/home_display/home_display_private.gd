class_name HomeDisplayPrivate
extends AbstractContainer
# Private class for HomeDisplay
# Generated automatically - DO NOT MODIFY

func _init() -> void:
	data_id = "home_display"
	data_name = "HomeDisplay"

	_layout_mode = LayoutMode.PATH
	_face_up = true

	# Grid parameters
	_grid_card_width = 200
	_grid_fixed_width = true
	_grid_card_spacing = Vector2(1, 1)
	_grid_halign = HALIGN_CENTER
	_grid_valign = VALIGN_CENTER
	_grid_columns = 3
	_grid_expand = true

	# Drag and drop parameters
	_drag_enabled = false
	_drop_enabled = false

	# Path parameters
	_path_card_width = 50
	_path_fixed_width = false
	_path_spacing = 0.9

	# Position fine tuning
	_fine_pos = false
	_fine_pos_mode = FineTuningMode.LINEAR
	_fine_pos_min = Vector2(0, 0)
	_fine_pos_max = Vector2(0, 0)

	# Angle fine tuning
	_fine_angle = false
	_fine_angle_mode = FineTuningMode.LINEAR
	_fine_angle_min = deg2rad(0)
	_fine_angle_max = deg2rad(0)

	# Scale fine tuning
	_fine_scale = false
	_fine_scale_mode = FineTuningMode.LINEAR
	_fine_scale_ratio = AspectMode.KEEP
	_fine_scale_min = Vector2(0, 0)
	_fine_scale_max = Vector2(0, 0)

	# Transitions
	_transitions.order.duration = 0
	_transitions.order.type = Tween.TRANS_LINEAR
	_transitions.order.easing = Tween.EASE_IN

	_transitions.in_anchor.duration = 0
	_transitions.in_anchor.type = Tween.TRANS_LINEAR
	_transitions.in_anchor.easing = Tween.EASE_IN

	_transitions.out_anchor.duration = 0
	_transitions.out_anchor.type = Tween.TRANS_LINEAR
	_transitions.out_anchor.easing = Tween.EASE_IN

	_interactive = false
	_anim = "home"

	_adjust_mode = "focused"
	_adjust_pos_x_mode = "disabled"
	_adjust_pos_y_mode = "disabled"
	_adjust_pos = Vector2(0, 0)
	_adjust_scale_x_mode = "disabled"
	_adjust_scale_y_mode = "disabled"
	_adjust_scale = Vector2(0, 0)
	_adjust_rot_mode = "disabled"
	_adjust_rot = 0


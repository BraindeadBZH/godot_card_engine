class_name HandContainerPrivate
extends AbstractContainer
# Private class for HandContainer
# Generated automatically - DO NOT MODIFY

func _init() -> void:
	data_id = "hand"
	data_name = "HandContainer"

	_layout_mode = LayoutMode.GRID
	_face_up = true

	# Grid parameters
	_grid_card_width = 150
	_grid_fixed_width = true
	_grid_card_spacing = Vector2(0.5, 1)
	_grid_halign = HALIGN_CENTER
	_grid_valign = VALIGN_CENTER
	_grid_columns = -1
	_grid_expand = false

	# Drag and drop parameters
	_drag_enabled = true
	_drop_enabled = false

	# Path parameters
	_path_card_width = 200
	_path_fixed_width = true
	_path_spacing = 0.5

	# Position fine tuning
	_fine_pos = true
	_fine_pos_mode = FineTuningMode.SYMMETRIC
	_fine_pos_min = Vector2(0, -20)
	_fine_pos_max = Vector2(0, 20)

	# Angle fine tuning
	_fine_angle = true
	_fine_angle_mode = FineTuningMode.LINEAR
	_fine_angle_min = deg2rad(-10)
	_fine_angle_max = deg2rad(10)

	# Scale fine tuning
	_fine_scale = false
	_fine_scale_mode = FineTuningMode.LINEAR
	_fine_scale_ratio = AspectMode.KEEP
	_fine_scale_min = Vector2(0, 0)
	_fine_scale_max = Vector2(0, 0)

	# Transitions
	_transitions.order.duration = 0.5
	_transitions.order.type = Tween.TRANS_QUAD
	_transitions.order.easing = Tween.EASE_IN_OUT

	_transitions.in_anchor.duration = 0.75
	_transitions.in_anchor.type = Tween.TRANS_BACK
	_transitions.in_anchor.easing = Tween.EASE_OUT

	_transitions.out_anchor.duration = 0.3
	_transitions.out_anchor.type = Tween.TRANS_QUAD
	_transitions.out_anchor.easing = Tween.EASE_IN_OUT

	_interactive = true
	_anim = "hand"

	_adjust_mode = "focused"
	_adjust_pos_x_mode = "disabled"
	_adjust_pos_y_mode = "absolute"
	_adjust_pos = Vector2(0, 0)
	_adjust_scale_x_mode = "disabled"
	_adjust_scale_y_mode = "disabled"
	_adjust_scale = Vector2(0, 0)
	_adjust_rot_mode = "absolute"
	_adjust_rot = 0


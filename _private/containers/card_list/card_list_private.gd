class_name CardListPrivate
extends AbstractContainer
# Private class for CardList
# Generated automatically - DO NOT MODIFY

func _init():
	data_id = "card_list"
	data_name = "CardList"

	_layout_mode = LayoutMode.GRID
	_face_up = true

	# Grid parameters
	_grid_card_width = 200
	_grid_fixed_width = false
	_grid_card_spacing = Vector2(1.2, 1.1)
	_grid_halign = HORIZONTAL_ALIGNMENT_CENTER
	_grid_valign = VERTICAL_ALIGNMENT_TOP
	_grid_columns = 4
	_grid_expand = true

	# Interaction parameters
	_interactive = true
	_exclusive = false
	_last_only = false
	_drag_enabled = true
	_drop_enabled = false

	# Path parameters
	_path_card_width = 200
	_path_fixed_width = true
	_path_spacing = 1

	# Position fine tuning
	_fine_pos = false
	_fine_pos_mode = FineTuningMode.LINEAR
	_fine_pos_min = Vector2(0, 0)
	_fine_pos_max = Vector2(0, 0)

	# Angle fine tuning
	_fine_angle = false
	_fine_angle_mode = FineTuningMode.LINEAR
	_fine_angle_min = deg_to_rad(0)
	_fine_angle_max = deg_to_rad(0)

	# Scale fine tuning
	_fine_scale = false
	_fine_scale_mode = FineTuningMode.LINEAR
	_fine_scale_ratio = AspectMode.KEEP
	_fine_scale_min = Vector2(0, 0)
	_fine_scale_max = Vector2(0, 0)

	# Transitions
	_transitions.layout.duration = 0.25
	_transitions.layout.type = Tween.TRANS_QUAD
	_transitions.layout.easing = Tween.EASE_IN_OUT

	_transitions.in_anchor.duration = 0.7
	_transitions.in_anchor.type = Tween.TRANS_BACK
	_transitions.in_anchor.easing = Tween.EASE_OUT

	_transitions.out_anchor.duration = 0.5
	_transitions.out_anchor.type = Tween.TRANS_QUAD
	_transitions.out_anchor.easing = Tween.EASE_IN

	# Animation
	_anim = "list"
	_adjust_mode = "focused"
	_adjust_pos_x_mode = "disabled"
	_adjust_pos_y_mode = "disabled"
	_adjust_pos = Vector2(0, 0)
	_adjust_scale_x_mode = "disabled"
	_adjust_scale_y_mode = "disabled"
	_adjust_scale = Vector2(0, 0)
	_adjust_rot_mode = "disabled"
	_adjust_rot = 0


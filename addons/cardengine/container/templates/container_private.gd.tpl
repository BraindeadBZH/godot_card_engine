class_name {container_name}Private
extends AbstractContainer
# Private class for {container_name}
# Generated automatically - DO NOT MODIFY

func _ready():
	_layout_mode = {mode}
	_face_up = {face_up}

	# Grid parameters
	_grid_card_width = {grid_width}
	_grid_fixed_width = {grid_fixed}
	_grid_card_spacing = Vector2({grid_spacing_h}, {grid_spacing_v})
	_grid_halign = {grid_align_h}
	_grid_valign = {grid_align_v}
	_grid_columns = {grid_columns}
	_grid_expand = {grid_expand}

	# Path parameters
	_path_card_width = {path_width}
	_path_fixed_width = {path_fixed}
	_path_spacing = {path_spacing}

	# Position fine tuning
	_fine_pos = {pos_enabled}
	_fine_pos_mode = {pos_mode}
	_fine_pos_min = Vector2({pos_range_min_h}, {pos_range_min_v})
	_fine_pos_max = Vector2({pos_range_max_h}, {pos_range_max_v})

	# Angle fine tuning
	_fine_angle = {angle_enabled}
	_fine_angle_mode = {angle_mode}
	_fine_angle_min = deg2rad({angle_range_min})
	_fine_angle_max = deg2rad({angle_range_max})

	# Scale fine tuning
	_fine_scale = {scale_enabled}
	_fine_scale_mode = {scale_mode}
	_fine_scale_ratio = {scale_ratio}
	_fine_scale_min = Vector2({scale_range_min_h}, {scale_range_min_v})
	_fine_scale_max = Vector2({scale_range_max_h}, {scale_range_max_v})
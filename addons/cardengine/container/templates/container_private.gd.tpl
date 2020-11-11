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

	# Transitions
	_transitions.order.duration = {order_duration}
	_transitions.order.type = {order_type}
	_transitions.order.easing = {order_easing}

	_transitions.in_anchor.duration = {in_duration}
	_transitions.in_anchor.type = {in_type}
	_transitions.in_anchor.easing = {in_easing}

	_transitions.out_anchor.duration = {out_duration}
	_transitions.out_anchor.type = {out_type}
	_transitions.out_anchor.easing = {out_easing}

	_transitions.flip_start.duration = {flip_start_duration}
	_transitions.flip_start.type = {flip_start_type}
	_transitions.flip_start.easing = {flip_start_easing}

	_transitions.flip_end.duration = {flip_end_duration}
	_transitions.flip_end.type = {flip_end_type}
	_transitions.flip_end.easing = {flip_end_easing}

	_interactive = {interactive}
	_idle_anim = "{idle_anim}"
	_idle_anim_repeat = {idle_anim_repeat}
	_focused_anim = "{focused_anim}"
	_focused_anim_repeat = {focused_anim_repeat}
	_clicked_anim = "{clicked_anim}"
	_clicked_anim_repeat = {clicked_anim_repeat}
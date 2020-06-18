class_name HomeDisplayPrivate
extends AbstractContainer
# Private class for HomeDisplay
# Generated automatically - DO NOT MODIFY

func _ready():
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

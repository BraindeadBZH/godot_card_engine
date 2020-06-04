class_name {container_name}Private
extends AbstractContainer
# Private class for {container_name}
# Generated automatically - DO NOT MODIFY

func _ready():
	_layout_mode = {mode}

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

tool
class_name ContainerData
extends Reference

var id: String = ""
var name: String = ""
var mode: String = "grid"
var face_up: bool = true

# Grid parameters
var grid_card_width: float = 200
var grid_fixed_width: bool = true
var grid_card_spacing: Vector2 = Vector2(1.0, 1.0)
var grid_halign: String = "center"
var grid_valign: String = "middle"
var grid_columns: int = 3
var grid_expand: bool = true

# Drag and drop parameters
var drag_enabled: bool = false
var drop_enabled: bool = false

# Path parameters
var path_card_width: float = 200
var path_fixed_width: bool = true
var path_spacing: float = 1.0

# Position fine tuning
var fine_pos: bool = false
var fine_pos_mode: String = "linear"
var fine_pos_min: Vector2 = Vector2(0.0, 0.0)
var fine_pos_max: Vector2 = Vector2(0.0, 0.0)

# Angle fine tuning
var fine_angle: bool = false
var fine_angle_mode: String = "linear"
var fine_angle_min: float = 0.0
var fine_angle_max: float = 0.0

# Scale fine tuning
var fine_scale: bool = false
var fine_scale_mode: String = "linear"
var fine_scale_ratio: String = "keep"
var fine_scale_min: Vector2 = Vector2(0.0, 0.0)
var fine_scale_max: Vector2 = Vector2(0.0, 0.0)

# Tansitions
var order_duration: float = 0.3
var order_type: String = "linear"
var order_easing: String = "in"

var in_duration: float = 0.3
var in_type: String = "linear"
var in_easing: String = "in"

var out_duration: float = 0.3
var out_type: String = "linear"
var out_easing: String = "in"

var flip_start_duration: float = 0.3
var flip_start_type: String = "linear"
var flip_start_easing: String = "in"

var flip_end_duration: float = 0.3
var flip_end_type: String = "linear"
var flip_end_easing: String = "in"

# Animations
var interactive: bool = true
var anim: String = "none"

var adjust_mode: String = "focused"
var adjust_pos_x_mode: String = "disabled"
var adjust_pos_y_mode: String = "disabled"
var adjust_pos: Vector2 = Vector2(0.0, 0.0)
var adjust_scale_x_mode: String = "disabled"
var adjust_scale_y_mode: String = "disabled"
var adjust_scale: Vector2 = Vector2(0.0, 0.0)
var adjust_rot_mode: String = "disabled"
var adjust_rot: float = 0.0


func _init(id: String, name: String) -> void:
	self.id = id
	self.name = name

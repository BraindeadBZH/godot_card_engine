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
var fine_scale_ratio = "keep"
var fine_scale_min: Vector2 = Vector2(0.0, 0.0)
var fine_scale_max: Vector2 = Vector2(0.0, 0.0)


func _init(id: String, name: String) -> void:
	self.id = id
	self.name = name

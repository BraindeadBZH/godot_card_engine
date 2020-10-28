class_name CardTransform
extends Reference


var pos: Vector2 = Vector2(0.0, 0.0)
var scale: Vector2 = Vector2(1.0, 1.0)
var rot: float = 0.0


func eq(other: CardTransform) -> bool:
	return pos == other.pos and scale == other.scale and rot == other.rot

tool
class_name AnimationBlock
extends Reference

var _from_mode: int
var _to_mode: int

var _pos_seq: PositionSequence
var _scale_seq: ScaleSequence
var _rot_seq: RotationSequence


func _init(from_mode: int, to_mode: int) -> void:
	_from_mode = from_mode
	_to_mode = to_mode
	_pos_seq = PositionSequence.new(from_mode, to_mode)
	_scale_seq = ScaleSequence.new(from_mode, to_mode)
	_rot_seq = RotationSequence.new(from_mode, to_mode)


func position_sequence() -> PositionSequence:
	return _pos_seq


func scale_sequence() -> ScaleSequence:
	return _scale_seq


func rotation_sequence() -> RotationSequence:
	return _rot_seq

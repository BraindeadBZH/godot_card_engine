@tool
class_name AnimationData
extends RefCounted

var id: String = ""
var name: String = ""

var _idle: AnimationBlock = AnimationBlock.new(AnimationSequence.INIT_ORIGIN, AnimationSequence.INIT_ORIGIN)
var _focused: AnimationBlock = AnimationBlock.new(AnimationSequence.INIT_ORIGIN, AnimationSequence.INIT_DISABLED)
var _activated: AnimationBlock = AnimationBlock.new(AnimationSequence.INIT_FOCUSED, AnimationSequence.INIT_DISABLED)
var _deactivated: AnimationBlock = AnimationBlock.new(AnimationSequence.INIT_ACTIVATED, AnimationSequence.INIT_FOCUSED)
var _unfocused: AnimationBlock = AnimationBlock.new(AnimationSequence.INIT_FOCUSED, AnimationSequence.INIT_ORIGIN)


func _init(id: String, name: String):
	self.id = id
	self.name = name


func idle_loop() -> AnimationBlock:
	return _idle


func focused_animation() -> AnimationBlock:
	return _focused


func activated_animation() -> AnimationBlock:
	return _activated


func deactivated_animation() -> AnimationBlock:
	return _deactivated


func unfocused_animation() -> AnimationBlock:
	return _unfocused

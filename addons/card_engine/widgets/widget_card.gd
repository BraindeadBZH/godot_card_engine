# CardWidget class - Renders a card
extends Node2D

const FORMAT_LABEL = "lbl_%s"
const FORMAT_IMAGE = "img_%s"

# The size the card should be if no specific size apply
export(Vector2) var default_size = Vector2(100, 200)
# Animation speed in second
export(float) var animation_speed = 1

signal mouse_entered()
signal mouse_exited()
signal mouse_motion(relative)
signal mouse_pressed(button)
signal mouse_released(button)

class AnimationState extends Reference:
	var pos = Vector2(0, 0)
	var rot = 0
	var scale = Vector2(1, 1)

var _card_data = null
var _is_ready = false
var _animation = Tween.new()
var _animation_stack = []

func _init():
	add_child(_animation)

# Returns the ideal scale given the card's default size and the given size
func calculate_scale(size):
	var ratio = size / default_size
	var result = Vector2(1, 1)
	if ratio.x > ratio.y:
		result = Vector2(ratio.y, ratio.y)
	else:
		result = Vector2(ratio.x, ratio.x)
	return result

func _ready():
	_is_ready = true
	
	$mouse_area.connect("mouse_entered", self, "_on_mouse_area_entered")
	$mouse_area.connect("mouse_exited", self, "_on_mouse_area_exited")
	$mouse_area.connect("gui_input", self, "_on_mouse_area_event")
	
	_animation.connect("tween_completed", self, "_on_animation_completed")
	
	_update_card()
	_animation.start()

func _exit_tree():
	_animation.stop_all()

# Sets the data to use for displaying a card with this widget
func set_card_data(card_data):
	_card_data = card_data
	_update_card()
	_card_data.connect("changed", self, "_update_card")

# Returns the date used by this widget
func get_card_data():
	return _card_data

# Makes the card appear in front of others Node2D
func bring_front():
	z_index = VisualServer.CANVAS_ITEM_Z_MAX

# Makes the card appear behind of others Node2D
func send_back():
	z_index = VisualServer.CANVAS_ITEM_Z_MIN

# Makes the card returns to its normal z position
func reset_z_index():
	z_index = 0

# Adds an animation state from the current values
func push_animation_state_from_current():
	var state = AnimationState.new()
	state.pos = position
	state.rot = rotation_degrees
	state.scale = scale
	_animation_stack.push_back(state)

# Adds an animation state from the given values and animate the card to the state
func push_animation_state(pos, rot, scale_ratio, is_pos_relative=false, is_rot_relative=false, is_scale_relative=false):
	var previous_state = null
	if !_animation_stack.empty():
		previous_state = _animation_stack.back()
	else:
		previous_state = AnimationState.new()
		previous_state.pos = position
		previous_state.rot = rotation_degrees
		previous_state.scale = scale
		
	var state = AnimationState.new()
	state.pos = pos if !is_pos_relative else previous_state.pos + pos
	state.rot = rot if !is_rot_relative else previous_state.rot + rot
	state.scale = scale_ratio if !is_scale_relative else previous_state.scale*scale_ratio
	_animation_stack.push_back(state)
	_animate(previous_state, state)

# Removes the last animation state and animate the card to the previous state
func pop_animation_state():
	if _animation_stack.empty(): return
	var state = _animation_stack.pop_back()
	if !_animation_stack.empty():
		var previous_sate = _animation_stack.back()
		_animate(state, previous_sate)

# Internal animation from one state to another
func _animate(from_state, to_state):
	_animation.interpolate_property(
		self, "position", from_state.pos, to_state.pos, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT)

	_animation.interpolate_property(
		self, "rotation_degrees", from_state.rot, to_state.rot, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT)

	_animation.interpolate_property(
		self, "scale", from_state.scale, to_state.scale, animation_speed, Tween.TRANS_BACK, Tween.EASE_OUT)

func _update_card():
	if _card_data == null || !_is_ready: return
	
	# Images update
	for image in _card_data.images:
		var node = find_node(FORMAT_IMAGE % image)
		if node != null:
			var id = _card_data.images[image]
			if id != "default":
				node.texture = load(CardEngine.card_image(image, id))
	
	# Value update
	for value in _card_data.values:
		var node = find_node(FORMAT_LABEL % value)
		if node != null:
			node.text = "%d" % CardEngine.final_value(_card_data, value)
	
	# Text update
	for text in _card_data.texts:
		var node = find_node(FORMAT_LABEL % text)
		if node != null:
			if node is RichTextLabel:
				node.bbcode_text = CardEngine.final_text(_card_data, text)
			else:
				node.text = CardEngine.final_text(_card_data, text)

func _on_mouse_area_entered():
	emit_signal("mouse_entered")

func _on_mouse_area_exited():
	emit_signal("mouse_exited")

func _on_mouse_area_event(event):
	if event is InputEventMouseMotion:
		emit_signal("mouse_motion", event.relative)
	elif event is InputEventMouseButton:
		if event.pressed:
			emit_signal("mouse_pressed", event.button_index)
		else:
			emit_signal("mouse_released", event.button_index)

func _on_animation_completed(object, key):
	_animation.remove(object, key)

# CardWidget class - Renders a card
extends Node2D

const FORMAT_LABEL = "lbl_%s"
const FORMAT_IMAGE = "img_%s"

# The size the card should be if no specific size apply
export(Vector2) var default_size = Vector2(100, 200)
# The actual size of the card
export(Vector2) var card_size = Vector2(100, 200) setget set_card_size
# Animation speed in second
export(float) var animation_speed = 1

signal mouse_entered()
signal mouse_exited()
signal mouse_motion(relative)

var _card_data = null
var _is_ready = false
var _initial_pos = Vector2(0, 0)
var _initial_rot = 0
var _initial_scale = scale
var _animation = Tween.new()

func _init():
	add_child(_animation)

func set_card_size(new_size):
	card_size = new_size
	_on_resized()

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

# Makes the card appear in front of others Node2D
func bring_front():
	z_index = VisualServer.CANVAS_ITEM_Z_MAX

# Makes the card appear behind of others Node2D
func send_back():
	z_index = VisualServer.CANVAS_ITEM_Z_MIN

# Makes the card returns to its normal z position
func reset_z_index():
	z_index = 0

# Sets the intial position for animation purpose
func set_initial_position(pos):
	_initial_pos = pos

# Moves the card by the given amount
func move(amount):
	_animation.interpolate_property(
		self, "position", _initial_pos, _initial_pos + amount, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Moves the card to the given value
func move_to(value):
	_animation.interpolate_property(
		self, "position", _initial_pos, value, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Moves the card back to its intial position
func reset_position():
	_animation.interpolate_property(
		self, "position", position, _initial_pos, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Set the intial rotation for animation purpose
func set_initial_rotation(rot):
	_initial_rot = rot

# Rotates the card by the given amount
func rotate(amount):
	_animation.interpolate_property(
		self, "rotation_degrees", _initial_rot, _initial_rot + amount, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Rotates the card to the given value
func rotate_to(value):
	_animation.interpolate_property(
		self, "rotation_degrees", _initial_rot, value, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Rotates the card back to its initial rotation
func reset_rotation():
	_animation.interpolate_property(
		self, "rotation_degrees", rotation_degrees, _initial_rot, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Set the intial rotation for animation purpose
func set_initial_scale():
	_initial_scale = scale

# Scales the card by the given ratio
func scale_relative(ratio):
	_animation.interpolate_property(self, "scale", _initial_scale, _initial_scale*ratio, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Scales the card to the given value
func scale_to(value):
	_animation.interpolate_property(
		self, "scale", _initial_scale, Vector2(value, value), animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

# Scales the card to its initial scale
func reset_scale():
	_animation.interpolate_property(
		self, "scale", scale, _initial_scale, animation_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

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

func _on_resized():
	var ratio = card_size / default_size
	if ratio.x > ratio.y:
		scale = Vector2(ratio.y, ratio.y)
	else:
		scale = Vector2(ratio.x, ratio.x)

func _on_mouse_area_entered():
	emit_signal("mouse_entered")

func _on_mouse_area_exited():
	emit_signal("mouse_exited")

func _on_mouse_area_event(event):
	if event is InputEventMouseMotion:
		emit_signal("mouse_motion", event.relative)

func _on_animation_completed(object, key):
	_animation.remove(object, key)

# HandWidget class - Display cards like you have them in hand
extends Control

# Amount the card overlaps horizontally to reduce hand's width
export(int) var card_overlap = 30
# Amount the card is offset vertically, at 0 only the top-half of the card is within the hand's height
export(int) var vertical_offset = 20
# Cumulative angle between cards in degree
export(float) var card_angle = 3
# Amount the card is moved when the mouse hover it
export(Vector2) var mouse_hover_offset = Vector2(0, -100)
# Amount the card is moved vertically when selected
export(int) var selected_vertical_offset = -100

var _container = null
var _focused_card = null

func _ready():
	connect("resized", self, "_on_resized")

func set_container(container):
	_container = container
	_update_hand()
	_container.connect("size_changed", self, "_on_container_size_changed")

func set_focused_card(card):
	if _focused_card != null: return
	_focused_card = card
	_focused_card.bring_front()
	_focused_card.move(mouse_hover_offset)
	_focused_card.rotate_to(0)

func unset_focused_card(card):
	if _focused_card != card: return
	_focused_card.reset_z_index()
	_focused_card.reset_position()
	_focused_card.reset_rotation()
	_focused_card = null

func set_selected_card(card):
	if _focused_card != card: return
	_focused_card.move_to(Vector2(rect_size.x/2, selected_vertical_offset))
	_focused_card.scale_relative(1.5)

func unset_selected_card(card):
	if _focused_card != card: return
	_focused_card.reset_position()
	_focused_card.reset_scale()

func _update_hand():
	for child in get_children():
		remove_child(child)
	
	for card in _container.cards():
		var card_widget = CEInterface.card_instance()
		card_widget.set_card_data(card)
		add_child(card_widget)
		
		card_widget.connect("mouse_entered", self, "_on_card_mouse_entered", [card_widget])
		card_widget.connect("mouse_exited", self, "_on_card_mouse_exited", [card_widget])
		card_widget.connect("mouse_pressed", self, "_on_card_mouse_pressed", [card_widget])
		card_widget.connect("mouse_released", self, "_on_card_mouse_released", [card_widget])
	
	# If the Hand is displayed we call resize to update widgets position and size
	if is_inside_tree(): _on_resized()

func _on_resized():
	yield(get_tree(), "idle_frame")
	var card_index = 0
	var total_card = _container.size()
	var half_total = float(total_card) / 2.0 # Using float to deal with odd card number
	var final_overlap = card_overlap
	var card_widget = CEInterface.card_instance()
	
	# Size calculations
	var card_height = rect_size.y*2
	var ratio = card_height / card_widget.default_size.y
	var size = Vector2(round(card_widget.default_size.x * ratio), card_height)
	
	# Overlap check
	var total_width = (size.x - card_overlap) * total_card
	if total_width > rect_size.x:
		# If the hand is larger than the widget, we recalculate an overlap which make all the cards visible
		final_overlap = ceil((size.x*total_card-rect_size.x)/(total_card-1))
	
	for card_widget in get_children():
		# Position calculations
		var middle = rect_size.x/2 
		var dist = float(card_index) - half_total + 0.5 # We add 0.5 so the distance is from the middle of the card
		var pos = Vector2(middle+dist*(size.x-final_overlap), -vertical_offset+card_height/2)
		
		# Rotation calculations
		var rot = card_angle*dist
		
		card_widget.set_card_size(size)
		card_widget.set_initial_scale()
		card_widget.position = pos
		card_widget.rotation_degrees = rot
		card_widget.set_initial_position(pos)
		card_widget.set_initial_rotation(rot)
		
		card_index += 1

func _on_container_size_changed(new_size):
	_update_hand()

func _on_card_mouse_entered(card):
	set_focused_card(card)

func _on_card_mouse_exited(card):
	unset_focused_card(card)

func _on_card_mouse_pressed(button, card):
	if button == BUTTON_LEFT:
		set_selected_card(card)

func _on_card_mouse_released(button, card):
	if button == BUTTON_LEFT:
		unset_selected_card(card)

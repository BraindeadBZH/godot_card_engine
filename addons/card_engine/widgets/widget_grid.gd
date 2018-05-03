# GridWidget class - Display cards in a grid
extends Control

# Space in pixels between the cards horizontally and vertically
export(Vector2) var card_spacing = Vector2(0, 0)
# Number of columns
export(int) var columns = 3

var _container = null

func _ready():
	connect("resized", self, "_on_resized")

func set_container(container):
	_container = container
	_update_grid()

func _update_grid():
	for child in get_children():
		remove_child(child)

	for card in _container.cards():
		var card_widget = CEInterface.card_instance()
		card_widget.set_card_data(card)
		
		card_widget.connect("mouse_entered", self, "_on_card_mouse_entered", [card_widget])
		card_widget.connect("mouse_exited", self, "_on_card_mouse_exited", [card_widget])
		
		add_child(card_widget)
	
	_on_resized()

func _on_resized():
	yield(get_tree(), "idle_frame")
	var card_index = 0
	var total_card = _container.size()
	var card_widget = CEInterface.card_instance()
	var final_row = 0
	
	# Size calculations
	var card_width = round((rect_size.x - (columns+1)*card_spacing.x) / columns)
	var ratio = card_width / card_widget.default_size.x
	var size = Vector2(card_width, round(card_widget.default_size.y * ratio))
		
	for card_widget in get_children():
		# Position calculations
		var col = card_index%columns
		var row = floor(card_index / columns)
		var pos = size*Vector2(col, row) + Vector2(size.x, size.y)/2 + card_spacing*Vector2(col+1, row+1)
		
		if row > final_row:
			final_row = row
		
		card_widget.set_card_size(size)
		card_widget.position = pos
		card_widget.push_animation_state_from_current()
		
		card_index += 1
	
	# Minimum height calculation to fit all rows
	rect_min_size.y = (final_row+1)*(size.y + card_spacing.y)

func _on_card_mouse_entered(card):
	card.bring_front()
	card.push_animation_state(Vector2(0, 0), 0, Vector2(1.25, 1.25), true, true, true)

func _on_card_mouse_exited(card):
	card.pop_animation_state()
	card.reset_z_index()

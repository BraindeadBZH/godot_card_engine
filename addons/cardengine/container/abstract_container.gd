class_name AbstractContainer
extends Control

signal card_clicked(card)
signal card_dropped(card)

const CARD_NODE_FMT = "card_%s"

enum LayoutMode {GRID, PATH}
enum FineTuningMode {LINEAR, SYMMETRIC, RANDOM}
enum AspectMode {KEEP, IGNORE}

export(PackedScene) var card_visual: PackedScene = null
export(PackedScene) var drag_widget: PackedScene = null
export(NodePath) var in_anchor: NodePath = ""
export(NodePath) var out_anchor: NodePath = ""

var data_id: String = ""
var data_name: String = ""

var _store: AbstractStore = null
var _rng: PseudoRng = PseudoRng.new()

var _layout_mode: int = LayoutMode.GRID
var _face_up: float = true

# Grid parameters
var _grid_card_width: float = 200
var _grid_fixed_width: bool = true
var _grid_card_spacing: Vector2 = Vector2(0.75, 1.2)
var _grid_halign: int = HALIGN_CENTER
var _grid_valign: int = VALIGN_CENTER
var _grid_columns: int = -1
var _grid_expand: bool = true

# Drag and drop parameters
var _drag_enabled: bool = false
var _drop_enabled: bool = false

# Path parameters
var _path_card_width: float = 200
var _path_fixed_width: bool = false
var _path_spacing: float = 0.5

# Position fine tuning
var _fine_pos: bool = false
var _fine_pos_mode = FineTuningMode.SYMMETRIC
var _fine_pos_min: Vector2 = Vector2(0.0, 0.0)
var _fine_pos_max: Vector2 = Vector2(0.0, 60.0)

# Angle fine tuning
var _fine_angle: bool = false
var _fine_angle_mode = FineTuningMode.RANDOM
var _fine_angle_min: float = deg2rad(-10.0)
var _fine_angle_max: float = deg2rad(10.0)

# Scale fine tuning
var _fine_scale: bool = false
var _fine_scale_mode = FineTuningMode.RANDOM
var _fine_scale_ratio = AspectMode.KEEP
var _fine_scale_min: Vector2 = Vector2(0.85, 0.85)
var _fine_scale_max: Vector2 = Vector2(1.15, 1.15)

# Transitions
var _transitions: CardTransitions = CardTransitions.new()

# Animations
var _interactive: bool = true
var _anim: String = "none"

var _adjust_mode: String = "focused"
var _adjust_pos_x_mode: String = "disabled"
var _adjust_pos_y_mode: String = "disabled"
var _adjust_pos: Vector2 = Vector2(0.0, 0.0)
var _adjust_scale_x_mode: String = "disabled"
var _adjust_scale_y_mode: String = "disabled"
var _adjust_scale: Vector2 = Vector2(0.0, 0.0)
var _adjust_rot_mode: String = "disabled"
var _adjust_rot: float = 0.0

onready var _cards = $DropArea/Cards
onready var _path = $CardPath
onready var _drop_area = $DropArea


func _ready() -> void:
	_drop_area.set_enabled(_drop_enabled)


func store() -> AbstractStore:
	return _store


func set_store(store: AbstractStore) -> void:
	_store = store
	_store.connect("changed", self, "_update_container")
	_update_container()


func get_drop_area() -> DropArea:
	return _drop_area


func _card_clicked(card: AbstractCard) -> void:
	pass


func _update_container() -> void:
	if card_visual == null:
		return

	if _store == null:
		return

	_clear()

	if not in_anchor.is_empty():
		var anchor = get_node(in_anchor)
		if anchor is Node2D:
			_transitions.in_anchor.enabled = true
			_transitions.in_anchor.position = anchor.position
			_transitions.in_anchor.scale = anchor.scale
			_transitions.in_anchor.rotation = anchor.rotation
		elif anchor is Control:
			_transitions.in_anchor.enabled = true
			_transitions.in_anchor.position = anchor.rect_position
			_transitions.in_anchor.scale = anchor.rect_scale
			_transitions.in_anchor.rotation = deg2rad(anchor.rect_rotation)

	if not out_anchor.is_empty():
		var anchor = get_node(out_anchor)
		if anchor is Node2D:
			_transitions.out_anchor.enabled = true
			_transitions.out_anchor.position = anchor.position
			_transitions.out_anchor.scale = anchor.scale
			_transitions.out_anchor.rotation = anchor.rotation
		elif anchor is Control:
			_transitions.out_anchor.enabled = true
			_transitions.out_anchor.position = anchor.rect_position
			_transitions.out_anchor.scale = anchor.rect_scale
			_transitions.out_anchor.rotation = deg2rad(anchor.rect_rotation)

	# Adding missing cards
	for card in _store.cards():
		if _cards.find_node(CARD_NODE_FMT % card.ref(), false, false) != null:
			continue

		var visual_inst := card_visual.instance()
		if not visual_inst is AbstractCard:
			printerr("Container visual instance must inherit AbstractCard")
			continue

		visual_inst.name = CARD_NODE_FMT % card.ref()
		_cards.add_child(visual_inst)
		visual_inst.set_instance(card)
		visual_inst.set_container(data_id)
		visual_inst.set_transitions(_transitions)
		visual_inst.set_interactive(_interactive)
		visual_inst.set_drag_enabled(_drag_enabled)
		visual_inst.set_drag_widget(drag_widget)
		visual_inst.set_animation(CardEngine.anim().get_animation(_anim))
		visual_inst.connect("need_removal", self, "_on_need_removal", [visual_inst])
		visual_inst.connect("clicked", self, "_on_card_clicked", [visual_inst])

		if _face_up:
			visual_inst.set_side(AbstractCard.CardSide.FRONT)
		else:
			visual_inst.set_side(AbstractCard.CardSide.BACK)

	# Sorting according to store order
	var index = 0
	for card in _store.cards():
		var visual = _cards.find_node(CARD_NODE_FMT % card.ref(), false, false)
		_cards.move_child(visual, index)
		index += 1

	_layout_cards()


func _layout_cards():
	var card_index: int = 0

	for child in _cards.get_children():
		if child is AbstractCard && not child.is_flagged_for_removal():
			var trans = CardTransform.new()

			match _layout_mode:
				LayoutMode.GRID:
					_grid_layout(trans, card_index, child.size)
				LayoutMode.PATH:
					_path_layout(trans, card_index, child.size)

			_fine_tune(trans, card_index, child.size)

			child.set_root_trans(trans)
			child.set_adjusted_trans(
				_adjusted_trans(trans),
				_adjust_mode == "focused",
				_adjust_mode == "activated")
			card_index += 1


func _grid_layout(trans: CardTransform, grid_cell: int, card_size: Vector2):
	var width_ratio: float = 0.0
	var height_adjusted: float = 0.0
	var row_width: float = 0.0
	var col_height: float = 0.0
	var grid_offset: Vector2 = Vector2(0.0, 0.0)
	var spacing_offset: Vector2 = Vector2(0.0, 0.0)

	# Card size
	if not _grid_fixed_width:
		if _grid_columns > 0:
			_grid_card_width = rect_size.x / (_grid_columns * _grid_card_spacing.x)
		else:
			_grid_card_width = rect_size.x / (_store.count() * _grid_card_spacing.x)

	width_ratio = _grid_card_width / card_size.x
	height_adjusted = card_size.y * width_ratio

	# Grid offset
	if _grid_columns > 0:
		row_width = _grid_columns * _grid_card_width * _grid_card_spacing.x
		col_height = ceil(_store.count() / float(_grid_columns)) * height_adjusted * _grid_card_spacing.y
	else:
		row_width = _store.count() * _grid_card_width * _grid_card_spacing.x
		col_height = height_adjusted * _grid_card_spacing.y

	if _grid_expand:
		if row_width > rect_size.x:
			rect_min_size.x = row_width

		if col_height > rect_size.y || _grid_columns > 0:
			rect_min_size.y = col_height

	spacing_offset.x = (_grid_card_width * _grid_card_spacing.x - _grid_card_width) / 2.0
	spacing_offset.y = (height_adjusted * _grid_card_spacing.y - height_adjusted) / 2.0

	match _grid_halign:
		HALIGN_LEFT:
			grid_offset.x = spacing_offset.x
		HALIGN_CENTER:
			grid_offset.x = spacing_offset.x + (rect_size.x - row_width) / 2.0
		HALIGN_RIGHT:
			grid_offset.x = spacing_offset.x + (rect_size.x - row_width)

	match _grid_valign:
		VALIGN_TOP:
			grid_offset.y = spacing_offset.y
		VALIGN_CENTER:
			grid_offset.y = spacing_offset.y + (rect_size.y - col_height) / 2.0
		VALIGN_BOTTOM:
			grid_offset.y = spacing_offset.y + (rect_size.y - col_height)

	var pos: Vector2 = Vector2(0.0 , 0.0)
	# Initial pos
	pos.x = _grid_card_width / 2.0
	pos.y = height_adjusted / 2.0

	# Cell align pos
	if _grid_columns > 0:
		pos.x += _grid_card_width * _grid_card_spacing.x * (grid_cell % _grid_columns)
		pos.y += height_adjusted * _grid_card_spacing.y * ceil(grid_cell / _grid_columns)
	else:
		pos.x += _grid_card_width * _grid_card_spacing.x * grid_cell

	# Grid align pos
	pos.x += grid_offset.x
	pos.y += grid_offset.y

	trans.scale = Vector2(width_ratio, width_ratio)
	trans.pos = pos


func _path_layout(trans: CardTransform, card_index: int, card_size: Vector2):
	var width_ratio: float = 0.0
	var curve: Curve2D = _path.get_curve()
	var path_length: float = curve.get_baked_length()
	var path_offset: float = 0.0
	var path_offset_delta: float = 0.0

	if not _path_fixed_width:
		_path_card_width = path_length / (_store.count() * _path_spacing)

	width_ratio = _path_card_width / card_size.x

	# Path offset
	path_offset_delta = path_length - _path_card_width
	path_offset_delta /= _store.count() - 1
	path_offset = _path_card_width / 2 + path_offset_delta * card_index

	trans.scale =  Vector2(width_ratio, width_ratio)
	trans.pos = curve.interpolate_baked(path_offset)


func _fine_tune(trans: CardTransform, card_index: int, card_size: Vector2):
	var card_count: float = _store.count() - 1.0

	if _fine_pos:
		match _fine_pos_mode:
			FineTuningMode.LINEAR:
				if card_count > 0:
					trans.pos += lerp(
						_fine_pos_min,
						_fine_pos_max,
						card_index / card_count)
			FineTuningMode.SYMMETRIC:
				if card_count > 0:
					trans.pos += lerp(
						_fine_pos_min,
						_fine_pos_max,
						abs(((card_index * 2.0) / card_count) - 1.0))
			FineTuningMode.RANDOM:
				trans.pos += _rng.random_vec2_range(_fine_pos_min, _fine_pos_max)

	if _fine_angle:
		match _fine_angle_mode:
			FineTuningMode.LINEAR:
				if card_count > 0:
					trans.rot += lerp_angle(
						_fine_angle_min,
						_fine_angle_max,
						card_index / card_count)
			FineTuningMode.SYMMETRIC:
				if card_count > 0:
					trans.rot += lerp_angle(
						_fine_angle_min,
						_fine_angle_max,
						abs(((card_index * 2.0) / card_count) - 1.0))
			FineTuningMode.RANDOM:
				trans.rot += _rng.randomf_range(_fine_angle_min, _fine_angle_max)

	if _fine_scale:
		match _fine_scale_mode:
			FineTuningMode.LINEAR:
				if card_count > 0:
					trans.scale *= lerp(
						_fine_scale_min,
						_fine_scale_max,
						card_index / card_count)
			FineTuningMode.SYMMETRIC:
				if card_count > 0:
					trans.scale *= lerp(
						_fine_scale_min,
						_fine_scale_max,
						abs(((card_index * 2.0) / card_count) - 1.0))
			FineTuningMode.RANDOM:
				match _fine_scale_ratio:
					AspectMode.IGNORE:
						trans.scale *= _rng.random_vec2_range(_fine_scale_min, _fine_scale_max)
					AspectMode.KEEP:
						var random_scale = _rng.randomf_range(_fine_scale_min.x, _fine_scale_max.x)
						trans.scale *= Vector2(random_scale, random_scale)


func _adjusted_trans(origin: CardTransform) -> CardTransform:
	var adjusted := CardTransform.new()
	var has_adjust := false

	adjusted.pos = origin.pos
	adjusted.scale = origin.scale
	adjusted.rot = origin.rot

	if _adjust_pos_x_mode == "relative":
		adjusted.pos.x += _adjust_pos.x
		has_adjust = true
	elif _adjust_pos_x_mode == "absolute":
		adjusted.pos.x = _adjust_pos.x
		has_adjust = true

	if _adjust_pos_y_mode == "relative":
		adjusted.pos.y += _adjust_pos.y
		has_adjust = true
	elif _adjust_pos_y_mode == "absolute":
		adjusted.pos.y = _adjust_pos.y
		has_adjust = true

	if _adjust_scale_x_mode == "relative":
		adjusted.scale.x *= _adjust_scale.x
		has_adjust = true
	elif _adjust_scale_x_mode == "absolute":
		adjusted.scale.x = _adjust_scale.x
		has_adjust = true

	if _adjust_scale_y_mode == "relative":
		adjusted.scale.y *= _adjust_scale.y
		has_adjust = true
	elif _adjust_scale_y_mode == "absolute":
		adjusted.scale.y = _adjust_scale.y
		has_adjust = true

	if _adjust_rot_mode == "relative":
		adjusted.rot += deg2rad(_adjust_rot)
		has_adjust = true
	elif _adjust_rot_mode == "absolute":
		adjusted.rot = deg2rad(_adjust_rot)
		has_adjust = true

	if has_adjust:
		return adjusted
	else:
		return null


func _clear() -> void:
	if _cards == null:
		return

	for child in _cards.get_children():
		if not _store.has_card(child.instance().ref()):
			child.flag_for_removal()


func _on_AbstractContainer_resized() -> void:
	_update_container()


func _on_need_removal(card: AbstractCard) -> void:
	_cards.remove_child(card)
	card.queue_free()


func _on_card_clicked(card: AbstractCard) -> void:
	if _interactive:
		_card_clicked(card)
		emit_signal("card_clicked", card)


func _on_DropArea_dropped(card: CardInstance) -> void:
	emit_signal("card_dropped", card)

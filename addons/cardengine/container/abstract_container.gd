class_name AbstractContainer
extends Control

enum LayoutMode {GRID, PATH}

export(PackedScene) var card_visual: PackedScene = null
export(String) var database: String = ""
export(Dictionary) var query: Dictionary = {"from": [], "where": [], "contains": []}

var _store: AbstractStore = null

var _layout_mode = LayoutMode.PATH

# Grid parameters
var _grid_card_width: float = 200
var _grid_fixed_width: bool = true
var _grid_card_spacing: Vector2 = Vector2(1.2, 1.2)
var _grid_halign: int = HALIGN_CENTER
var _grid_valign: int = VALIGN_CENTER
var _grid_columns: int = 3
var _grid_fluid: bool = true

# Path parameters
var _path_card_width: float = 200
var _path_spacing: float = 0.5

onready var _manager = CardEngine.db()
onready var _cards = $Cards
onready var _path = $CardPath


func set_store(store: AbstractStore) -> void:
	_store = store
	_update_store()


func _update_store() -> void:
	_store.clear()
	
	var db = _manager.get_database(database)
	if db == null:
		printerr("Database '%s' not found" % database)
		return
	
	var q = Query.new()
	q.from(query["from"]).where(query["where"]).contains(query["contains"])
	db.exec_query(q, _store)
	
	_update_container()


func _update_container() -> void:
	if card_visual == null:
		return
	
	_clear()
	
	for card in _store.cards():
		var instance := card_visual.instance()
		if not instance is AbstractCard:
			printerr("Container visual instance must inherit AbstractCard")
			continue
		
		instance.name = card.id
		_cards.add_child(instance)
		instance.set_data(card)
	
	_layout_cards()


func _layout_cards():
	match _layout_mode:
		LayoutMode.GRID:
			_grid_layout()
		LayoutMode.PATH:
			_path_layout()


func _grid_layout():
	var visual_instance: AbstractCard = card_visual.instance()
	var grid_cell: int = 0
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
	
	width_ratio = _grid_card_width / visual_instance.size.x
	height_adjusted = visual_instance.size.y * width_ratio
	
	# Grid offset
	if _grid_columns > 0:
		row_width = _grid_columns * _grid_card_width * _grid_card_spacing.x
		col_height = ceil(_store.count() / float(_grid_columns)) * height_adjusted * _grid_card_spacing.y
	else:
		row_width = _store.count() * _grid_card_width * _grid_card_spacing.x
		col_height = height_adjusted * _grid_card_spacing.y
	
	if _grid_fluid:
		if row_width > rect_size.x:
			rect_min_size.x = row_width
		
		if col_height > rect_size.y:
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
	
	for child in _cards.get_children():
		if child is AbstractCard:
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
			
			child.scale = Vector2(width_ratio, width_ratio)
			child.position = pos
			grid_cell += 1
	
	visual_instance.queue_free()


func _path_layout():
	var visual_instance: AbstractCard = card_visual.instance()
	var width_ratio: float = _path_card_width / visual_instance.size.x
	var curve: Curve2D = _path.get_curve()
	var path_length: float = curve.get_baked_length()
	var path_offset: float = 0.0
	var path_offset_delta: float = 0.0

	# Path offset
	path_offset = _path_card_width / 2
	path_offset_delta = path_length - _path_card_width
	path_offset_delta /= _store.count() - 1
	
	for child in _cards.get_children():
		if child is AbstractCard:
			var pos: Vector2 = curve.interpolate_baked(path_offset)
			child.scale = Vector2(width_ratio, width_ratio)
			child.position = pos
			path_offset += path_offset_delta
	
	visual_instance.queue_free()


func _clear() -> void:
	if _cards == null:
		return
	
	for child in _cards.get_children():
		_cards.remove_child(child)


func _on_AbstractContainer_resized():
	_layout_cards()

extends AbstractScreen

var _selected_categ: String = ""
var _selected_val: String = ""

onready var _container = $LibraryBg/LibraryScroll/LibraryContainer
onready var _categs = $TitleBg/Categories
onready var _values = $TitleBg/Values
onready var _comp_op = $TitleBg/ComparisonOperator
onready var _comp_val = $TitleBg/ComparisonValue


func _ready():
	if _container != null:
		_container.set_store(CardDeck.new())
		_update_filters()


func _apply_filters():
	var from: Array = []
	var where: Array = []
	var contains: Array = []
	
	if not _categs.selected == 0:
		from.append(_selected_categ)
	
	if not _values.selected == 0:
		where.append(
			"%s %s %d" % [
				_selected_val,
				_comp_op.get_item_text(_comp_op.selected),
				_comp_val.value])
	
	_container.set_query({
			"from": from,
			"where": where,
			"contains": contains})
	
	_update_filters()


func _update_filters():
	_update_categs()
	_update_values()


func _update_categs():
	_categs.clear()
	_categs.add_item("All")
	for id in _container.store().categories():
		var categ = _container.store().get_category(id)
		_categs.add_item("%s (%d)" % [categ["name"], categ["count"]])
		_categs.set_item_metadata(_categs.get_item_count() - 1, id)
		if id == _selected_categ:
			_categs.select(_categs.get_item_count() - 1)


func _update_values():
	_values.clear()
	_values.add_item("None")
	for id in _container.store().values():
		_values.add_item(id)
		if id == _selected_val:
			_values.select(_values.get_item_count() - 1)


func _on_BackBtn_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_Categories_item_selected(id):
	if id == 0:
		_selected_categ = "all"
	else:
		_selected_categ = _categs.get_item_metadata(id)
	
	_apply_filters()


func _on_Values_item_selected(id):
	if id == 0:
		_selected_val = "none"
	else:
		_selected_val = _values.get_item_text(id)
	
	_apply_filters()


func _on_ComparisonValue_value_changed(_value):
	_apply_filters()


func _on_ComparisonOperator_item_selected(_id):
	_apply_filters()

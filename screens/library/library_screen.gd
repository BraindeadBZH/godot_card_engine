extends AbstractScreen

var _store: CardDeck = CardDeck.new()
var _selected_categ: String = "all"
var _selected_val: String = "none"
var _selected_txt: String = "none"

onready var _manager = CardEngine.db()
onready var _container = $LibraryBg/LibraryScroll/LibraryContainer
onready var _categs = $TitleBg/Categories
onready var _values = $TitleBg/Values
onready var _comp_op = $TitleBg/ComparisonOperator
onready var _comp_val = $TitleBg/ComparisonValue
onready var _texts = $TitleBg/Texts
onready var _contains = $TitleBg/Contains


func _ready():
	if _container != null:
		_apply_filters()


func _apply_filters():
	var from: Array = []
	var where: Array = []
	var contains: Array = []
	
	if _categs.selected > 0:
		from.append(_selected_categ)
	
	if _values.selected > 0:
		where.append(
			"%s %s %d" % [
				_selected_val,
				_comp_op.get_item_text(_comp_op.selected),
				_comp_val.value])
	
	if _texts.selected > 0 and not _contains.text.empty():
		contains.append("%s:%s" % [_selected_txt, _contains.text])
	
	_store.clear()
	
	var db = _manager.get_database("main")
	var q = Query.new()
	q.from(from).where(where).contains(contains)
	db.exec_query(q, _store)
	_store.sort_by_value("mana")
	_container.set_store(_store)
	
	if _store.count() > 0:
		_update_filters()


func _update_filters():
	_update_categs()
	_update_values()
	_update_texts()


func _update_categs():
	_categs.clear()
	_categs.add_item("All")
	for id in _store.categories():
		var categ = _store.get_category(id)
		_categs.add_item("%s (%d)" % [categ["name"], categ["count"]])
		_categs.set_item_metadata(_categs.get_item_count() - 1, id)
		if id == _selected_categ:
			_categs.select(_categs.get_item_count() - 1)


func _update_values():
	_values.clear()
	_values.add_item("None")
	for id in _store.values():
		_values.add_item(id)
		if id == _selected_val:
			_values.select(_values.get_item_count() - 1)


func _update_texts():
	_texts.clear()
	_texts.add_item("None")
	for id in _store.texts():
		_texts.add_item(id)
		if id == _selected_txt:
			_texts.select(_texts.get_item_count() - 1)


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


func _on_Texts_item_selected(id):
	if id == 0:
		_selected_txt = "none"
	else:
		_selected_txt = _texts.get_item_text(id)
	
	_apply_filters()


func _on_Contains_text_changed(_new_text):
	_apply_filters()

extends AbstractScreen

var _selected_categ: String = ""

onready var _container = $LibraryBg/LibraryScroll/LibraryContainer
onready var _categs = $TitleBg/Categories


func _ready():
	if _container != null:
		_container.set_store(CardDeck.new())
		_update_categs()


func _update_categs():
	_categs.clear()
	_categs.add_item("All")
	for id in _container.store().categories():
		var categ = _container.store().get_category(id)
		_categs.add_item("%s (%d)" % [categ["name"], categ["count"]])
		_categs.set_item_metadata(_categs.get_item_count() - 1, id)
		if id == _selected_categ:
			_categs.select(_categs.get_item_count() - 1)


func _on_BackBtn_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_Categories_item_selected(id):
	if id == 0:
		_selected_categ = "all"
		_container.set_query({
			"from": [],
			"where": [],
			"contains": []})
	else:
		var categ = _categs.get_item_metadata(id)
		_selected_categ = categ
		_container.set_query({
			"from": [categ],
			"where": [],
			"contains": []})
	
	_update_categs()

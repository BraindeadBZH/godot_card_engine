extends AbstractScreen

var _store: CardDeck = CardDeck.new()
var _deck: CardDeck = CardDeck.new()
var _selected_class: String = "none"
var _selected_rarity: String = "none"
var _selected_val: String = "none"
var _selected_txt: String = "none"

onready var _scroll = $BuilderLayout/LibraryBg/LibraryScroll
onready var _container = $BuilderLayout/LibraryBg/LibraryScroll/LibraryContainer
onready var _class = $TitleBg/TitleLayout/CategoriesLayout/ClassLayout/Class
onready var _rarity = $TitleBg/TitleLayout/CategoriesLayout/RarityLayout/Rarity
onready var _values = $TitleBg/TitleLayout/ValuesLayout/Values
onready var _comp_op = $TitleBg/TitleLayout/ValuesLayout/ComparisionLayout/ComparisonOperator
onready var _comp_val = $TitleBg/TitleLayout/ValuesLayout/ComparisionLayout/ComparisonValue
onready var _texts = $TitleBg/TitleLayout/TextsLayout/Texts
onready var _contains = $TitleBg/TitleLayout/TextsLayout/Contains
onready var _rarity_sort = $TitleBg/TitleLayout/SortLayout/RaritySort
onready var _mana_sort = $TitleBg/TitleLayout/SortLayout/ManaSort
onready var _name_sort = $TitleBg/TitleLayout/SortLayout/NameSort
onready var _deck_list = $BuilderLayout/DeckBg/CardDrop/DeckLayout/DeckScroll/DeckList


func _ready() -> void:
	var db = CardEngine.db().get_database("main")

	_store.populate_all(db)
	_container.set_store(_store)
	_apply_filters()


func _apply_filters() -> void:
	var from: Array = [""]
	var where: Array = []
	var contains: Array = []

	if _selected_class != "none":
		from[0] += "class:%s" % _selected_class

	if _selected_rarity != "none":
		if not from[0].empty():
			from[0] += ","
		from[0] += "rarity:%s" % _selected_rarity

	if _values.selected > 0:
		where.append(
			"%s %s %d" % [
				_selected_val,
				_comp_op.get_item_text(_comp_op.selected),
				_comp_val.value])

	if _texts.selected > 0 and not _contains.text.empty():
		contains.append("%s:%s" % [_selected_txt, _contains.text])


	var filter = Query.new()
	filter.from(from).where(where).contains(contains)

	_store.apply_filter(filter)

	var sorting: Dictionary = {}

	if _rarity_sort.pressed:
		sorting["category:rarity"] = ["common", "uncommon", "rare", "mythic_rare"]

	if _mana_sort.pressed:
		sorting["value:mana"] = true

	if _name_sort.pressed:
		sorting["text:name"] = true

	if not sorting.empty():
		_store.sort(sorting)

	if _store.count() > 0:
		_update_filters()


func _update_filters() -> void:
	_update_class()
	_update_rarity()
	_update_values()
	_update_texts()


func _update_class() -> void:
	var classes = _store.get_meta_category("class")
	var index = 1
	var selected = 0

	_class.clear()
	_class.add_item("All")
	_class.set_item_metadata(0, "none")

	for clazz in classes["values"]:
		_class.add_item("%s (%d)" % [clazz, classes["values"][clazz]])
		_class.set_item_metadata(index, clazz)
		if clazz == _selected_class:
			selected = index
		index += 1

	_class.select(selected)


func _update_rarity() -> void:
	var rarities = _store.get_meta_category("rarity")
	var index = 1
	var selected = 0

	_rarity.clear()
	_rarity.add_item("All")
	_rarity.set_item_metadata(0, "none")

	for rarity in rarities["values"]:
		_rarity.add_item("%s (%d)" % [rarity, rarities["values"][rarity]])
		_rarity.set_item_metadata(index, rarity)
		if rarity == _selected_rarity:
			selected = index
		index += 1

	_rarity.select(selected)


func _update_values() -> void:
	_values.clear()
	_values.add_item("None")
	for id in _store.values():
		_values.add_item(id)
		if id == _selected_val:
			_values.select(_values.get_item_count() - 1)


func _update_texts() -> void:
	_texts.clear()
	_texts.add_item("None")
	for id in _store.texts():
		_texts.add_item(id)
		if id == _selected_txt:
			_texts.select(_texts.get_item_count() - 1)


func _update_deck_list() -> void:
	Utils.delete_all_children(_deck_list)

	var added_cards := []
	for card in _deck.cards():
		if added_cards.has(card.data().id):
			continue
		else:
			added_cards.append(card.data().id)

		var count = _deck.count_for(card.data().id)
		var layout = HBoxContainer.new()
		var btn = Button.new()
		var lbl = Label.new()

		layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var mana = card.data().get_value("mana")
		if mana >= 0:
			btn.text = "%s (%d)" % [card.data().get_text("name"), mana]
		else:
			btn.text = "%s (X)" % card.data().get_text("name")

		btn.clip_text = true
		btn.rect_min_size = Vector2(100, 30)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		lbl.text = "%d x" % count

		layout.add_child(lbl)
		layout.add_child(btn)
		_deck_list.add_child(layout)


func _on_BackBtn_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_Class_item_selected(index: int) -> void:
	if index == 0:
		_selected_class = "none"
	else:
		_selected_class = _class.get_item_metadata(index)

	_apply_filters()


func _on_Rarity_item_selected(index: int) -> void:
	if index == 0:
		_selected_rarity = "none"
	else:
		_selected_rarity = _rarity.get_item_metadata(index)

	_apply_filters()


func _on_Values_item_selected(id) -> void:
	if id == 0:
		_selected_val = "none"
	else:
		_selected_val = _values.get_item_text(id)

	_apply_filters()


func _on_ComparisonValue_value_changed(_value) -> void:
	_apply_filters()


func _on_ComparisonOperator_item_selected(_id) -> void:
	_apply_filters()


func _on_Texts_item_selected(id) -> void:
	if id == 0:
		_selected_txt = "none"
	else:
		_selected_txt = _texts.get_item_text(id)

	_apply_filters()


func _on_Contains_text_changed(_new_text) -> void:
	_apply_filters()


func _on_RaritySort_toggled(_button_pressed: bool) -> void:
	_apply_filters()


func _on_ManaSort_toggled(_button_pressed: bool) -> void:
	_apply_filters()


func _on_NameSort_toggled(_button_pressed: bool) -> void:
	_apply_filters()


func _on_LibraryScroll_resized() -> void:
	if _scroll != null:
		_container.rect_min_size = _scroll.rect_size


func _on_CardDrop_dropped(card: CardInstance) -> void:
	_deck.add_card(CardInstance.new(card.data()))
	_update_deck_list()

tool
extends WindowDialog

signal edit_card(card, db)
signal delete_card(card, db)

onready var _card_list = $MainLayout/CardsLayout/CardList
onready var _detail_list = $MainLayout/CardsLayout/DetailsLayout/DetailsList
onready var _delete_btn = $MainLayout/CardsLayout/DetailsLayout/ToolsLayout/DeleteBtn
onready var _edit_btn = $MainLayout/CardsLayout/DetailsLayout/ToolsLayout/EditBtn

var _db: CardDatabase = null
var _selected_card_idx: int = -1
var _selected_card: String = ""

func set_database(id: String):
	_clear_lists()
	
	_db = CardEngine.db().get_database(id)
	
	var cards = _db.cards()
	for card_id in cards:
		var card = cards[card_id]
		_card_list.add_item(card.id)

func remove_selected_card():
	_card_list.remove_item(_selected_card_idx)
	_detail_list.clear()
	_delete_btn.disabled = true
	_edit_btn.disabled = true

func _clear_lists():
	_card_list.clear()
	_detail_list.clear()

func _on_DoneBtn_pressed():
	hide()

func _on_EditDatabaseDialog_about_to_show():
	_delete_btn.disabled = true
	_edit_btn.disabled = true
	_clear_lists()

func _on_CardList_item_selected(index):
	_detail_list.clear()
	
	_selected_card_idx = index
	_selected_card = _card_list.get_item_text(index)
	
	var card = _db.get_card(_selected_card)
	_detail_list.add_item("Categories:")
	for categ in card.categories():
		_detail_list.add_item("  * %s: %s" % [categ, card.get_category(categ)])
		
	_detail_list.add_item("Values:")
	for value in card.values():
		_detail_list.add_item("  * %s = %d" % [value, card.get_value(value)])
		
	_detail_list.add_item("Texts:")
	for text in card.texts():
		_detail_list.add_item("  * %s:" % text)
		var lines = card.get_text(text).split("\n")
		for line in lines:
			_detail_list.add_item("       %s" % line)
	
	_delete_btn.disabled = false
	_edit_btn.disabled = false

func _on_EditBtn_pressed():
	emit_signal("edit_card", _selected_card, _db.id)
	hide()

func _on_DeleteBtn_pressed():
	emit_signal("delete_card", _selected_card, _db.id)

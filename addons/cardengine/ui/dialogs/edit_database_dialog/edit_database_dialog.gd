tool
extends WindowDialog

signal edit_card(card, db)

var _db: CardDatabase = null
var _selected_card: String = ""

func set_database(id: String):
	_clear_lists()
	
	_db = CardEngine.db().get_database(id)
	
	var cards = _db.cards()
	for card_id in cards:
		var card = cards[card_id]
		$MainLayout/CardsLayout/CardList.add_item(card.id)

func _clear_lists():
	$MainLayout/CardsLayout/CardList.clear()
	$MainLayout/CardsLayout/DetailsLayout/DetailsList.clear()

func _on_DoneBtn_pressed():
	hide()

func _on_EditDatabaseDialog_about_to_show():
	$MainLayout/CardsLayout/DetailsLayout/ToolsLayout/DeleteBtn.disabled = true
	$MainLayout/CardsLayout/DetailsLayout/ToolsLayout/EditBtn.disabled = true
	_clear_lists()

func _on_CardList_item_selected(index):
	var list = $MainLayout/CardsLayout/DetailsLayout/DetailsList
	list.clear()
	
	_selected_card = $MainLayout/CardsLayout/CardList.get_item_text(index)
	
	var card = _db.get_card(_selected_card)
	list.add_item("Categories:")
	for categ in card.categories():
		list.add_item("  * %s: %s" % [categ, card.get_category(categ)])
		
	list.add_item("Values:")
	for value in card.values():
		list.add_item("  * %s = %d" % [value, card.get_value(value)])
		
	list.add_item("Texts:")
	for text in card.texts():
		list.add_item("  * %s:" % text)
		var lines = card.get_text(text).split("\n")
		for line in lines:
			list.add_item("       %s" % line)
	
	$MainLayout/CardsLayout/DetailsLayout/ToolsLayout/DeleteBtn.disabled = false
	$MainLayout/CardsLayout/DetailsLayout/ToolsLayout/EditBtn.disabled = false

func _on_EditBtn_pressed():
	emit_signal("edit_card", _selected_card, _db.id)
	hide()

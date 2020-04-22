tool
extends WindowDialog

var _db: String = ""

func set_database(id: String):
	_clear_lists()
	_db = id
	var cards = CardEngine.db().get_database(id).cards()
	for card_id in cards:
		var card = cards[card_id]
		$MainLayout/CardsLayout/CardList.add_item(card.id)

func _clear_lists():
	$MainLayout/CardsLayout/CardList.clear()
	$MainLayout/CardsLayout/DetailsLayout/DetailsList.clear()

func _on_DoneBtn_pressed():
	hide()

func _on_EditDatabaseDialog_about_to_show():
	_clear_lists()

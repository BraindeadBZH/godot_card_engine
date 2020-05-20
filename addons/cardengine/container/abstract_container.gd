extends Control
class_name AbstractContainer

export(PackedScene) var card_visual
export(String) var database
export(Dictionary) var query = {"from": [], "where": [], "contains": []}

onready var _manager = CardEngine.db()

var _store: AbstractStore = null

func set_store(store: AbstractStore):
	_store = store
	_update_store()

func _update_store():
	_store.clear()
	
	var db = _manager.get_database(database)
	if db == null:
		printerr("Database '%s' not found" % database)
		return
	
	var q = Query.new()
	q.from(query["from"]).where(query["where"]).contains(query["contains"])
	db.exec_query(q, _store)
	
	_update_container()

func _update_container():
	# TODO
	for card in _store.cards():
		print("Card: %s" % card.id)

class_name AbstractContainer
extends Control

export(PackedScene) var card_visual
export(String) var database
export(Dictionary) var query = {"from": [], "where": [], "contains": []}

var _store: AbstractStore = null

onready var _manager = CardEngine.db()


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
	# TODO
	for card in _store.cards():
		print("Card: %s" % card.id)

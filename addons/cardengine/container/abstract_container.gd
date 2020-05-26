class_name AbstractContainer
extends Control

export(PackedScene) var card_visual: PackedScene = null
export(String) var database: String = ""
export(Dictionary) var query: Dictionary = {"from": [], "where": [], "contains": []}

var _store: AbstractStore = null

onready var _manager = CardEngine.db()
onready var _cards = $Cards


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


func _clear() -> void:
	if _cards == null:
		return
	
	for child in _cards.get_children():
		_cards.remove_child(child)

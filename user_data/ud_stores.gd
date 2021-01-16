class_name UDStores
extends Node

const STORE_SAVE_FILE: String = "user://stores.data"


func saved_stores() -> Dictionary:
	var file = ConfigFile.new()
	var err = file.load(STORE_SAVE_FILE)
	if err != OK:
		print("Could not open stores file")
		return {}

	var result = {}
	var stores = file.get_sections()

	for id in stores:
		result[id] = file.get_value(id, "name", "")

	return result


func load_store(id: String, dest: AbstractStore) -> void:
	var file = ConfigFile.new()
	var err = file.load(STORE_SAVE_FILE)
	if err != OK:
		print("Could not open stores file")
		return

	if not file.has_section(id):
		print("Store does not exist")
		return

	var name = file.get_value(id, "name", "")
	var cards = file.get_value(id, "cards", [])

	dest.save_id = id
	dest.save_name = name

	for card in cards:
		var db = CardEngine.db().get_database(card["source"])
		if db == null:
			continue
		var data = db.get_card(card["id"])
		if data == null:
			continue
		dest.add_card(CardInstance.new(data.duplicate()))


func save_store(id: String, name: String, store: AbstractStore) -> void:
	var file = ConfigFile.new()
	file.load(STORE_SAVE_FILE)

	var cards := []
	for card in store.cards():
		var data := {
			"id": card.data().id,
			"source": card.data().source_db,
		}
		cards.append(data)

	file.set_value(id, "name", name)
	file.set_value(id, "cards", cards)
	var err = file.save(STORE_SAVE_FILE)
	if err != OK:
		print("Could not save decks file")
		return

	store.save_id = id
	store.save_name = name

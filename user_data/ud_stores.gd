class_name UDStores
extends Node

const STORE_SAVE_FILE: String = "user://stores.data"


# Retrieves the list of all saved stores
# Customized this function to your need
# Returns a Dictionary:
# {
#   "<store id>": "<store name>",
#   "<store id>": "<store name>",
#   "<store id>": "<store name>",
#   ...
# }
func _get_stores() -> Dictionary:
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


# Retrieves the store with the given ID
# Customized this function to your need
# Returns a Dictionary:
# {
#   "id": "<store id>",
#   "name": "<store name>",
#   "cards": [
#     {"id": "<card id>", "source": "<database id>},
#     {"id": "<card id>", "source": "<database id>},
#     {"id": "<card id>", "source": "<database id>},
#     ...
#   ]
# }
func _get_store(id: String) -> Dictionary:
	var result := {
		"id": id,
		"name": "",
		"cards": []
	}

	var file = ConfigFile.new()
	var err = file.load(STORE_SAVE_FILE)
	if err != OK:
		print("Could not open stores file")
		return result

	if not file.has_section(id):
		print("Store does not exist")
		return result

	result["name"] = file.get_value(id, "name", "")
	result["cards"] = file.get_value(id, "cards", [])

	return result


# Saves a store with the given ID, name and cards
# Customized this function to your need
# Cards Array:
# [
#   {"id": "<card id>", "source": "<database id>},
#   {"id": "<card id>", "source": "<database id>},
#   {"id": "<card id>", "source": "<database id>},
#   ...
# ]
func _post_store(id: String, name: String, cards: Array) -> void:
	var file = ConfigFile.new()
	file.load(STORE_SAVE_FILE)

	file.set_value(id, "name", name)
	file.set_value(id, "cards", cards)
	var err = file.save(STORE_SAVE_FILE)
	if err != OK:
		print("Could not save decks file")
		return


func saved_stores() -> Dictionary:
	return _get_stores()


func load_store(id: String, dest: AbstractStore) -> void:
	var data := _get_store(id)

	dest.save_id = id
	dest.save_name = data["name"]

	for card in data["cards"]:
		var db = CardEngine.db().get_database(card["source"])
		if db == null:
			continue

		var card_data = db.get_card(card["id"])
		if card_data == null:
			continue

		dest.add_card(CardInstance.new(card_data.duplicate()))


func save_store(id: String, name: String, store: AbstractStore) -> void:
	var cards := []
	for card in store.cards():
		var data := {
			"id": card.data().id,
			"source": card.data().source_db,
		}
		cards.append(data)

	_post_store(id, name, cards)

	store.save_id = id
	store.save_name = name

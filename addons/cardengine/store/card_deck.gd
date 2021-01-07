class_name CardDeck
extends AbstractStore
# Manage available cards a game


func fill_random(amount: int, store: AbstractStore, allow_duplicate: bool = false) -> void:
	var selected = []
	while selected.size() < amount:
		var index = rng().random_range(0, count()-1)

		if !allow_duplicate and selected.has(index):
			continue

		store.add_card(get_card(index).duplicate())
		selected.append(index)

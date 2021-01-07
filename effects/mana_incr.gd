extends AbstractEffect


func _init(id: String, name: String).(id, name) -> void:
	pass


# Override this to limit the affected cards or leave null to affect all the cards
func get_filter() -> Query:
	var filter := Query.new()
	return filter.where(["mana >= 0"])


# Override this to returns an array of modifiers applied by this effect
func get_modifiers() -> Array:
	var modifiers := []

	modifiers.append(ValueChange.new("incr", true, "mana", 1))

	return modifiers


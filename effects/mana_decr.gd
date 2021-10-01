extends AbstractEffect


func _init(effect_id: String, effect_name: String):
	super(effect_id, effect_name)


# Override this to limit the affected cards or leave null to affect all the cards
func get_filter() -> Query:
	var filter := Query.new()
	return filter.where(["mana > 0"])


# Override this to returns an array of modifiers applied by this effect
func get_modifiers() -> Array:
	var modifiers := []

	modifiers.append(ValueChange.new("decr", true, "mana", -1))

	return modifiers


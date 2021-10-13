extends AbstractEffect


func _init(effect_id: String, effect_name: String):
	super(effect_id, effect_name)


# Override this to limit the affected cards or leave null to affect all the cards
func get_filter() -> Query:
	var filter := Query.new()
	return filter.from(["rarity:common"])


# Override this to returns an array of modifiers applied by this effect
func get_modifiers() -> Array[AbstractModifier]:
	var modifiers := []

	modifiers.append(ValueMultiplier.new("mult", false, "mana", 2.0))

	return modifiers


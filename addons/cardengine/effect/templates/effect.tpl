extends AbstractEffect


func _init(id: String, name: String).(id, name) -> void:
	pass


# Override this to limit the affected cards or leave null to affect all the cards
func get_filter() -> Query:
	return null


# Override this to returns an array of modifiers applied by this effect
func get_modifiers() -> Array:
	return []

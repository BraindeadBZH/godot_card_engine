class_name EffectInstance
extends Reference

var _fx: AbstractEffect = null
var _affected: Array = []


func _init(effect: AbstractEffect) -> void:
	_fx = effect


func ref() -> int:
	return get_instance_id()


func effect() -> AbstractEffect:
	return _fx


func apply(store: AbstractStore) -> void:
	for card in store.cards():
		affect(card)


func affect(card: CardInstance) -> void:
	var filter := _fx.get_filter()

	if filter == null or filter.match_card(card.data()):
		_affected.append(card)

		for mod in _fx.get_modifiers():
			mod.set_effect_ref(ref())
			card.add_modifier(mod)


func cancel() -> void:
	for card in _affected:
		card.remove_modifiers(ref())

	_affected.clear()

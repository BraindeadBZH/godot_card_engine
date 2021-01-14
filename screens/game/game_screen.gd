extends AbstractScreen

const STARTING_HAND_SIZE: int = 4
const MAX_HAND_SIZE: int = 8
const MAX_MANA: int = 10
const MAX_TOKENS: int = 4

var _mana_point := preload("res://screens/game/mana_point.png")
var _mana_empty := preload("res://screens/game/mana_empty.png")

var _hand: CardHand = CardHand.new()
var _draw_pile: CardPile = CardPile.new()
var _discard_pile: CardPile = CardPile.new()
var _tokens: CardPile = CardPile.new()
var _mana: int = MAX_MANA
var _fx_mana_mult: EffectInstance = null

onready var _hand_cont = $HandZone/HandContainer
onready var _draw_count = $DeckZone/DrawCount
onready var _draw_btn = $DeckZone/DrawBtn
onready var _discard_count = $DiscardZone/DiscardCount
onready var _reshuffle_btn = $DiscardZone/ReshuffleBtn
onready var _hand_delay = $StartingHandDelay
onready var _draw_filter = $EffectsLayout/FilterLayout/DrawFilter
onready var _hand_filter = $EffectsLayout/FilterLayout/HandFilter
onready var _discard_filter = $EffectsLayout/FilterLayout/DiscardFilter
onready var _on_played_fx = $EffectsLayout/OnPlayedEffect
onready var _token_grid = $PlayZone/TokenGrid


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_draw_pile.connect("changed", self, "_on_DrawPile_changed")
	# warning-ignore:return_value_discarded
	_discard_pile.connect("changed", self, "_on_DiscardPile_changed")
	# warning-ignore:return_value_discarded
	_hand.connect("changed", self, "_on_Hand_changed")

	_token_grid.set_store(_tokens)
	_token_grid.get_drop_area().set_source_filter(["hand"])

	if Gameplay.current_deck == null:
		var db = CardEngine.db().get_database("main")

		_draw_pile.populate_all(db)
	else:
		Gameplay.current_deck.copy_cards(_draw_pile)

	_draw_pile.shuffle()
	_hand_cont.set_store(_hand)
	_update_mana()


func _update_mana() -> void:
	for i in range(1, MAX_MANA+1):
		var ctrl: TextureRect = get_node("ManaBar/Mana%d" % i)
		if i <= _mana:
			ctrl.texture = _mana_point
		else:
			ctrl.texture = _mana_empty


func _apply_fx(fx: EffectInstance) -> void:
	if _draw_filter.pressed:
		fx.apply(_draw_pile)

	if _hand_filter.pressed:
		fx.apply(_hand)

	if _discard_filter.pressed:
		fx.apply(_discard_pile)


func _on_MenuBtn_pressed() -> void:
	emit_signal("next_screen", "menu")


func _on_DrawPile_changed() -> void:
	_draw_count.text = "%d" % _draw_pile.count()

	if _draw_pile.count() <= 0 or _hand.count() >= MAX_HAND_SIZE:
		_draw_btn.disabled = true
	else:
		_draw_btn.disabled = false


func _on_DiscardPile_changed() -> void:
	_discard_count.text = "%d" % _discard_pile.count()

	if _discard_pile.count() > 0:
		_reshuffle_btn.disabled = false
	else:
		_reshuffle_btn.disabled = true


func _on_Hand_changed() -> void:
	if _draw_pile.count() <= 0 or _hand.count() >= MAX_HAND_SIZE:
		_draw_btn.disabled = true
	else:
		_draw_btn.disabled = false


func _on_StartingHandDelay_timeout() -> void:
	var card = _draw_pile.draw()

	if card == null:
		return

	_hand.add_card(card)

	if _hand.count() >= STARTING_HAND_SIZE:
		_hand_delay.stop()
	else:
		_hand_delay.start(0.7)


func _on_DrawBtn_pressed() -> void:
	var card = _draw_pile.draw()

	if card == null:
		return

	_hand.add_card(card)


func _on_ReshuffleBtn_pressed() -> void:
	_discard_pile.move_cards(_draw_pile)
	_draw_pile.shuffle()


func _on_EndTurnBtn_pressed() -> void:
	_mana = MAX_MANA
	_update_mana()

	if _hand.count() < STARTING_HAND_SIZE:
		_hand_delay.start(0.1)


func _on_ManaMultiplier_toggled(button_pressed: bool) -> void:
	if button_pressed:
		_fx_mana_mult = CardEngine.fx().instantiate("mana_double")
		_apply_fx(_fx_mana_mult)
	else:
		if _fx_mana_mult != null:
			_fx_mana_mult.cancel()
			_fx_mana_mult = null


func _on_ManaIncrease_pressed() -> void:
	var fx = CardEngine.fx().instantiate("mana_incr")
	_apply_fx(fx)


func _on_ManaDecrease_pressed() -> void:
	var fx = CardEngine.fx().instantiate("mana_decr")
	_apply_fx(fx)


func _on_TokenGrid_card_clicked(card: AbstractCard) -> void:
	if card != null:
		_tokens.remove_card(card.instance().ref())


func _on_TokenGrid_card_dropped(card: CardInstance) -> void:
	if _tokens.count() >= MAX_TOKENS:
		return

	var card_mana = card.data().get_value("mana")

	if _mana >= card_mana:
		_hand.play_card(card.ref(), _discard_pile)
		_tokens.add_card(CardInstance.new(card.data()))

		if _on_played_fx.pressed:
			var fx = CardEngine.fx().instantiate("mana_incr")
			fx.affect(card)
		if card_mana < 0:
			_mana = 0
		else:
			_mana -= card_mana

		_update_mana()

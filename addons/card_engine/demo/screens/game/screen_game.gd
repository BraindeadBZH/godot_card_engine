extends "../abstract_screen.gd"

func _ready():
	$hand.set_container(CardEngine.player(CEInterface.PLAYER_PLAYER).hand())
	
	$btn_deck/lbl_deck_count.text = "%d" % CardEngine.player(CEInterface.PLAYER_PLAYER).deck(CEInterface.DECK_PLAYER).size()
	$btn_draw_pile/lbl_draw_pile_count.text = "%d" % CardEngine.player(CEInterface.PLAYER_PLAYER).pile(CEInterface.PILE_DRAW).size()
	CardEngine.player(CEInterface.PLAYER_PLAYER).pile(CEInterface.PILE_DRAW).connect("size_changed", self, "_on_draw_pile_size_changed")
	
	CardEngine.player(CEInterface.PLAYER_PLAYER).connect("energy_changed", self, "_on_player_energy_changed")
	_on_player_energy_changed()

func _on_btn_exit_pressed():
	emit_signal("next_screen", "menu")

func _on_draw_pile_size_changed(new_size):
	$btn_draw_pile/lbl_draw_pile_count.text = "%d" % new_size

func _on_player_energy_changed():
	var player = CardEngine.player(CEInterface.PLAYER_PLAYER)
	$img_energy/lbl_energy.text = "%d/%d" % [player.current_energy, player.max_energy]
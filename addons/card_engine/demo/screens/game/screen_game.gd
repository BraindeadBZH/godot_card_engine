extends "../abstract_screen.gd"

func _ready():
	$hand.set_container(DemoGame.player_hand)
	
	DemoGame.player_deck.connect("size_changed", self, "_update_deck")
	_update_deck(DemoGame.player_deck.size())
	
	DemoGame.player_draw.connect("size_changed", self, "_update_draw_pile")
	_update_draw_pile(DemoGame.player_draw.size())
	
	DemoGame.player_discard.connect("size_changed", self, "_update_discard_pile")
	_update_discard_pile(DemoGame.player_discard.size())
	
	DemoGame.connect("player_energy_changed", self, "_update_player_energy")
	_update_player_energy()

func _update_deck(new_size):
	$btn_deck/lbl_deck_count.text = "%d" % DemoGame.player_deck.size()

func _update_draw_pile(new_size):
	$btn_draw_pile/lbl_draw_pile_count.text = "%d" % new_size

func _update_discard_pile(new_size):
	$btn_discard_pile/lbl_discard_pile_count.text = "%d" % new_size

func _update_player_energy():
	$img_energy/lbl_energy.text = "%d/%d" % [DemoGame.player_energy, DemoGame.player_max_energy]

func _on_btn_exit_pressed():
	emit_signal("next_screen", "menu")

func _on_btn_draw_pile_pressed():
	DemoGame.draw_one_card()

func _on_btn_discard_pile_pressed():
	DemoGame.discard_random_card()

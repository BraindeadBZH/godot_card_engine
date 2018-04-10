extends "../abstract_screen.gd"

func _on_btn_fighter_pressed():
	CardEngine.start_game({"deck": "fighter_starter"})
	emit_signal("next_screen", "game")

func _on_btn_mage_pressed():
	CardEngine.start_game({"deck": "mage_starter"})
	emit_signal("next_screen", "game")

func _on_btn_back_pressed():
	emit_signal("next_screen", "menu")

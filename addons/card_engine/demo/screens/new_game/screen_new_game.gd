extends "../abstract_screen.gd"

func _on_btn_fighter_pressed():
	DemoGame.create_game("fighter_starter", "fighter")
	emit_signal("next_screen", "game")

func _on_btn_mage_pressed():
	DemoGame.create_game("mage_starter", "mage")
	emit_signal("next_screen", "game")

func _on_btn_back_pressed():
	emit_signal("next_screen", "menu")

extends "../abstract_screen.gd"

func _on_btn_fighter_pressed():
	# TODO: prepare for fighter
	emit_signal("next_screen", "game")

func _on_btn_mage_pressed():
	# TODO: prepare for mage
	emit_signal("next_screen", "game")

func _on_btn_back_pressed():
	emit_signal("next_screen", "menu")

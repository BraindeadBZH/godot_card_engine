extends "../abstract_screen.gd"

func _on_btn_new_game_pressed():
	emit_signal("next_screen", "new_game")

func _on_btn_library_pressed():
	emit_signal("next_screen", "library")

func _on_btn_quit_pressed():
	get_tree().quit()
extends AbstractScreen

func _on_NewGameBtn_pressed():
	emit_signal("next_screen", "new_game")

func _on_LibraryBtn_pressed():
	emit_signal("next_screen", "library")

func _on_QuitBtn_pressed():
	get_tree().quit()

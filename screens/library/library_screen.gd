extends AbstractScreen

func _on_BackBtn_pressed():
	emit_signal("next_screen", "menu")

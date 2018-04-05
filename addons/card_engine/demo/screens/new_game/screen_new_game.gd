extends "../abstract_screen.gd"

func _on_btn_back_pressed():
	emit_signal("next_screen", "menu")

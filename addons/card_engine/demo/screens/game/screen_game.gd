extends "../abstract_screen.gd"

func _ready():
	$hand.set_container(CardEngine.library())

func _on_btn_exit_pressed():
	# TODO: reset game
	emit_signal("next_screen", "menu")

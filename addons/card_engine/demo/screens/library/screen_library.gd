extends "../abstract_screen.gd"

func _ready():
	$grid_frame/grid_scroll/grid.set_container(CardEngine.library())

func _on_btn_back_pressed():
	emit_signal("next_screen", "menu")

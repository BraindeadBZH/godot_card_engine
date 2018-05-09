extends "../abstract_screen.gd"

const TEXT_ANIM_SPEED = 1.0

var _animation = Tween.new()

func _init():
	add_child(_animation)
	_animation.connect("tween_completed", self, "_on_animation_completed")

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
	
	DemoGame.connect("turn_started", self, "_on_turn_started")
	
	_change_step_text("Get ready!")

func _enter_tree():
	_animation.start()

func _exit_tree():
	_animation.stop_all()

func _change_step_text(text):
	$lbl_step.text = text
	_animation.interpolate_property(
		$lbl_step, "modulate", $lbl_step.modulate,  Color(1.0, 1.0, 1.0, 1.0), TEXT_ANIM_SPEED, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	yield(get_tree().create_timer(TEXT_ANIM_SPEED), "timeout")
	_animation.interpolate_property(
		$lbl_step, "modulate", $lbl_step.modulate,  Color(1.0, 1.0, 1.0, 0.0), TEXT_ANIM_SPEED, Tween.TRANS_CUBIC, Tween.EASE_OUT)

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

func _on_turn_started():
	_change_step_text("Your turn")

func _on_animation_completed(object, key):
	_animation.remove(object, key)

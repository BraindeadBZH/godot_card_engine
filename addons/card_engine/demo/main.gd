# Main scene - Demo main scene
extends Node

var _screens = {
		"menu": preload("res://addons/card_engine/demo/screens/menu/screen_menu.tscn"),
		"library": preload("res://addons/card_engine/demo/screens/library/screen_library.tscn"),
		"new_game": preload("res://addons/card_engine/demo/screens/new_game/screen_new_game.tscn")
	}

func _ready():
	change_screen("menu")

func change_screen(screen_name):
	if !_screens.has(screen_name): return
	
	for child in $screen_layer.get_children():
		$screen_layer.remove_child(child)
	
	var screen = _screens[screen_name].instance()
	screen.connect("next_screen", self, "change_screen")
	$screen_layer.add_child(screen)
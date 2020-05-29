extends Node

var _screens = {
	"menu": preload("res://screens/menu/menu_screen.tscn"),
	"library": preload("res://screens/library/library_screen.tscn")
}

onready var _screen_layer = $ScreenLayer


func _ready():
	randomize()
	CardEngine.clean()
	CardEngine.setup()
	change_screen("menu")


func change_screen(screen_name: String) -> void:
	if !_screens.has(screen_name): return
	
	for child in _screen_layer.get_children():
		_screen_layer.remove_child(child)
		child.queue_free()
	
	var screen = _screens[screen_name].instance()
	screen.connect("next_screen", self, "change_screen")
	_screen_layer.add_child(screen)

extends Node

var _screens : Dictionary = {
	"menu": preload("res://screens/menu/menu_screen.tscn"),
	"builder": preload("res://screens/builder/builder_screen.tscn"),
	"game": preload("res://screens/game/game_screen.tscn"),
	"board": preload("res://screens/board/board_screen.tscn")
}

@onready var _screen_layer = $ScreenLayer


func _ready():
	randomize()
	CardEngine.clean()
	CardEngine.setup()
	change_screen("menu")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if CardEngine.general().is_dragging():
			CardEngine.general().stop_drag()


func change_screen(screen_name: String) -> void:
	if !_screens.has(screen_name): return

	for child in _screen_layer.get_children():
		_screen_layer.remove_child(child)
		child.queue_free()

# warning-ignore:unsafe_cast
	var screen := (_screens[screen_name] as PackedScene).instantiate()
	screen.connect("next_screen", Callable(self, "change_screen"))
	_screen_layer.add_child(screen)

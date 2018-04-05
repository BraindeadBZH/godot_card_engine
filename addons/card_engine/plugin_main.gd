# PluginMain class - CardEngine plugin entry point
tool
extends EditorPlugin

func _enter_tree():
	print("CardEngine enabled")
	add_custom_type(
		"CardWidget", "Node2D",
		preload("res://addons/card_engine/widgets/widget_card.gd"),
		preload("res://addons/card_engine/icons/card-node.png"))
		
	add_custom_type(
		"GridWidget", "Control",
		preload("res://addons/card_engine/widgets/widget_grid.gd"),
		preload("res://addons/card_engine/icons/container-node.png"))
		
	add_custom_type(
		"HandWidget", "Control",
		preload("res://addons/card_engine/widgets/widget_hand.gd"),
		preload("res://addons/card_engine/icons/hand-node.png"))

func _exit_tree():
	print("CardEngine disabled")
	remove_custom_type("CardWidget")
	remove_custom_type("GridWidget")
	remove_custom_type("HandWidget")

# CEInterface class - Serves as an interface between your game and CardEngine
extends Node

var _custom_card = preload("res://<path to your custom card scene>")

# Returns the path to the file containing the card database
func database_path():
	return "res://<path to your JSON database>"

# Returns the path to the image with the given type and id
func card_image(img_type, img_id):
	return "res://<path to the image file>"

# Calculate the the given value of the given card taking into account possible buffs/debuffs
func calculate_final_value(card_data, value):
	return 0

# Returns an instance of the custom card design
func card_instance():
	return _custom_card.instance()

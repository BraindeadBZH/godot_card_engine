extends AbstractCard

onready var _name = $Front/NameBackground/Name
onready var _desc = $Front/DescBackground/Desc
onready var _cost = $Front/CostBackground/Cost
onready var _picture_group = $Front/PictureGroup
onready var _common = $Front/PictureGroup/Common
onready var _uncommon = $Front/PictureGroup/Uncommon
onready var _rare = $Front/PictureGroup/Rare
onready var _mythic_rare = $Front/PictureGroup/MythicRare
onready var _basic_land = $Front/PictureGroup/BasicLand
onready var _card_id = $Front/CardId


func _update_picture() -> void:
	for child in _picture_group.get_children():
		child.visible = false
		
	if _inst.data().has_category("common"):
		_common.visible = true
	elif _inst.data().has_category("uncommon"):
		_uncommon.visible = true
	elif _inst.data().has_category("rare"):
		_rare.visible = true
	elif _inst.data().has_category("mythic_rare"):
		_mythic_rare.visible = true
	elif _inst.data().has_category("basic_land"):
		_basic_land.visible = true


func _on_NormalCard_instance_changed() -> void:
	_card_id.text = _inst.data().id
	
	if _inst.data().has_text("name"):
		_name.text = _inst.data().get_text("name")
	
	if _inst.data().has_text("desc"):
		_desc.text = _inst.data().get_text("desc")
	
	if _inst.data().has_value("mana"):
		var val = _inst.data().get_value("mana")
		if val >= 0:
			_cost.text = "%d" % val
		else:
			_cost.text = "X"
	
	_update_picture()

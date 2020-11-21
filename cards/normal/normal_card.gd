extends AbstractCard

onready var _name = $AnimContainer/Front/NameBackground/Name
onready var _desc = $AnimContainer/Front/DescBackground/Desc
onready var _cost = $AnimContainer/Front/CostBackground/Cost
onready var _picture_group = $AnimContainer/Front/PictureGroup
onready var _common = $AnimContainer/Front/PictureGroup/Common
onready var _uncommon = $AnimContainer/Front/PictureGroup/Uncommon
onready var _rare = $AnimContainer/Front/PictureGroup/Rare
onready var _mythic_rare = $AnimContainer/Front/PictureGroup/MythicRare
onready var _basic_land = $AnimContainer/Front/PictureGroup/BasicLand
onready var _card_id = $AnimContainer/Front/CardId


func _update_picture() -> void:
	for child in _picture_group.get_children():
		child.visible = false
	
	if _inst.data().has_meta_category("rarity"):
		if _inst.data().get_category("rarity") == "common":
			_common.visible = true
		elif _inst.data().get_category("rarity") == "uncommon":
			_uncommon.visible = true
		elif _inst.data().get_category("rarity") == "rare":
			_rare.visible = true
		elif _inst.data().get_category("rarity") == "mythic_rare":
			_mythic_rare.visible = true
	elif _inst.data().has_meta_category("class"):
		if _inst.data().get_category("class") == "basic_land":
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

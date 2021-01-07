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


func _update_data(data: CardData, default: CardData = null) -> void:
	_card_id.text = data.id

	if data.has_text("name"):
		_name.text = data.get_text("name")

	if data.has_text("desc"):
		_desc.text = data.get_text("desc")

	if data.has_value("mana"):
		var val = data.get_value("mana")
		if val >= 0:
			_cost.text = "%d" % val
		else:
			_cost.text = "X"

	if default != null:
		var val = data.get_value("mana")
		var orig = default.get_value("mana")

		if val > orig:
			_cost.add_color_override("font_color", Color("ff0000"))
		elif val < orig:
			_cost.add_color_override("font_color", Color("00ff00"))
		else:
			_cost.add_color_override("font_color", Color("ffffff"))


	_update_picture(data)


func _update_picture(data: CardData) -> void:
	for child in _picture_group.get_children():
		child.visible = false

	if data.has_meta_category("rarity"):
		if data.get_category("rarity") == "common":
			_common.visible = true
		elif data.get_category("rarity") == "uncommon":
			_uncommon.visible = true
		elif data.get_category("rarity") == "rare":
			_rare.visible = true
		elif data.get_category("rarity") == "mythic_rare":
			_mythic_rare.visible = true
	elif data.has_meta_category("class"):
		if data.get_category("class") == "basic_land":
			_basic_land.visible = true


func _on_NormalCard_instance_changed() -> void:
	# warning-ignore:return_value_discarded
	instance().connect("modified", self, "_on_instance_modified")
	_update_data(instance().data(), instance().unmodified())


func _on_instance_modified() -> void:
	_update_data(instance().data(), instance().unmodified())

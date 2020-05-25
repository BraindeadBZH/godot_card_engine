extends AbstractCard

onready var _name = $Front/NameBackground/Name

func _on_NormalCard_data_changed():
	if _data.has_text("name"):
		_name.text = _data.get_text("name")

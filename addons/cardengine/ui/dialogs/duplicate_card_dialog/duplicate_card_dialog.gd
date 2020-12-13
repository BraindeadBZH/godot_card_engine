tool
extends AbstractFormDialog

onready var _card_id = $MainLayout/Form/CardId

var _db: String = ""


func _ready():
	setup("duplicate_card", CardEngine.db())


func _reset_form():
	_card_id.text = ""
	_db = ""


func _extract_form() -> Dictionary:
	return {
		"id": _card_id.text,
		"db": _db
	}


func _fill_form(data: Dictionary) -> void:
	_card_id.text = "%s_copy" % data["id"]
	_db = data["db"]


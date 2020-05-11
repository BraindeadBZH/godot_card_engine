tool
extends AbstractFormDialog

onready var _cont_id = $MainLayout/Form/ContainerId
onready var _cont_name = $MainLayout/Form/ContainerName
onready var _cont_visual = $MainLayout/Form/VisualLayout/ContainerVisual
onready var _select_dlg = $SelectDlg

func _ready():
	setup("new_container", CardEngine.cont())

func _reset_form():
	_cont_id.editable = true
	_cont_id.text = ""
	_cont_name.text = ""

func _extract_form() -> Dictionary:
	return {
		"id": _cont_id.text,
		"name": _cont_name.text,
		"visual": _cont_visual.text,
		"edit": is_edit()
	}

func _fill_form(data: Dictionary):
	_cont_id.editable = false
	_cont_id.text = data["id"]
	_cont_name.text = data["name"]
	_cont_visual.text = data["visual"]

func _on_SelectBtn_pressed():
	_select_dlg.popup_centered_minsize(Vector2(400, 250))

func _on_SelectDlg_file_selected(path):
	_cont_visual.text = path

tool
extends Control
class_name ContainersUi

onready var _cont_list = $ContainersLayout/ContainerList
onready var _delete_btn = $ContainersLayout/Toolbar/DeleteBtn

var _main_ui: CardEngineUI = null
var _selected_cont: int = -1

func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui

func _on_CreateBtn_pressed():
	_main_ui.show_new_container_dialog()

func _on_DeleteBtn_pressed():
	pass # Replace with function body.

func _on_ContainerList_item_selected(index):
	pass # Replace with function body.

func _on_ContainerList_item_activated(index):
	pass # Replace with function body.

func _on_NewContainerDialog_form_validated(form):
	pass # Replace with function body.

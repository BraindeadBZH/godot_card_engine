tool
class_name ContainersUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_cont: int = -1

onready var _manager = CardEngine.cont()
onready var _cont_list = $ContainersLayout/ContainerList
onready var _edit_btn = $ContainersLayout/Toolbar/EditBtn
onready var _open_btn = $ContainersLayout/Toolbar/OpenBtn
onready var _delete_btn = $ContainersLayout/Toolbar/DeleteBtn


func _ready():
	_manager.connect("changed", self, "_on_Containers_changed")


func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui


func delete_container() -> void:
	if yield():
		_manager.delete_container(
				_manager.get_container(
						_cont_list.get_item_metadata(_selected_cont)))


func _on_Containers_changed() -> void:
	if _cont_list == null: return

	_cont_list.clear()
	_edit_btn.disabled = true
	_open_btn.disabled = true
	_delete_btn.disabled = true

	var containers = CardEngine.cont().containers()
	for id in containers:
		var cont = containers[id]
		_cont_list.add_item("%s: %s" % [cont.id, cont.name])
		_cont_list.set_item_metadata(_cont_list.get_item_count()-1, cont.id)


func _on_CreateBtn_pressed() -> void:
	_main_ui.show_new_container_dialog()


func _on_EditBtn_pressed() -> void:
	_main_ui.show_edit_container_dialog(_cont_list.get_item_metadata(_selected_cont))


func _on_OpenBtn_pressed() -> void:
	_manager.open(_cont_list.get_item_metadata(_selected_cont))


func _on_DeleteBtn_pressed() -> void:
	_main_ui.show_confirmation_dialog(
			"Delete container", funcref(self, "delete_container"))


func _on_ContainerList_item_selected(index) -> void:
	_selected_cont = index
	_edit_btn.disabled = false
	_open_btn.disabled = false
	_delete_btn.disabled = false


func _on_ContainerList_item_activated(index) -> void:
	var cont = CardEngine.cont().get_container(_cont_list.get_item_metadata(index))
	_main_ui.show_new_container_dialog({"id": cont.id, "name": cont.name})


func _on_NewContainerDialog_form_validated(form) -> void:
	if form["edit"]:
		_manager.update_container(
			ContainerData.new(form["id"], form["name"]))
	else:
		_manager.create_container(
			ContainerData.new(form["id"], form["name"]))

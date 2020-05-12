tool
extends Control
class_name ContainersUi

onready var _manager = CardEngine.cont()
onready var _cont_list = $ContainersLayout/ContainerList
onready var _delete_btn = $ContainersLayout/Toolbar/DeleteBtn

var _main_ui: CardEngineUI = null
var _selected_cont: int = -1

func _ready():
	_manager.connect("changed", self, "_on_Containers_changed")

func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui

func delete_container():
	if yield():
		_manager.delete_container(
			_manager.get_container(
				_cont_list.get_item_metadata(_selected_cont)))

func _on_Containers_changed():
	if _cont_list == null: return

	_cont_list.clear()
	_delete_btn.disabled = true
	
	var containers = CardEngine.cont().containers()
	for id in containers:
		var cont = containers[id]
		_cont_list.add_item("%s: %s" % [cont.id, cont.name])
		_cont_list.set_item_metadata(_cont_list.get_item_count()-1, cont.id)

func _on_CreateBtn_pressed():
	_main_ui.show_new_container_dialog()

func _on_DeleteBtn_pressed():
	_main_ui.show_confirmation_dialog("Delete container", funcref(self, "delete_container"))

func _on_ContainerList_item_selected(index):
	_selected_cont = index
	_delete_btn.disabled = false

func _on_ContainerList_item_activated(index):
	var cont = CardEngine.cont().get_container(_cont_list.get_item_metadata(index))
	_main_ui.show_new_container_dialog({"id": cont.id, "name": cont.name, "visual": cont.visual})

func _on_NewContainerDialog_form_validated(form):
	if form["edit"]:
		_manager.update_container(
			ContainerData.new(form["id"], form["name"], form["visual"]))
	else:
		_manager.create_container(
			ContainerData.new(form["id"], form["name"], form["visual"]))

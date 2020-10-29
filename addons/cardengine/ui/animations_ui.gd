tool
class_name AnimationsUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_anim: int = -1
var _opened_anim: String = ""

onready var _manager = CardEngine.anim()
onready var _anim_list = $AnimationsLayout/Toolbar/AnimSelect
onready var _edit_btn = $AnimationsLayout/Toolbar/EditBtn
onready var _delete_btn = $AnimationsLayout/Toolbar/DeleteBtn
onready var _save_btn = $AnimationsLayout/Toolbar/SaveBtn


func _ready():
	_manager.connect("changed", self, "_on_Animations_changed")


func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui


func delete_animation() -> void:
	if yield():
		_manager.delete_animation(_anim_list.get_item_metadata(_selected_anim))
		_selected_anim = -1
		_opened_anim = ""


func _on_Animations_changed() -> void:
	if _anim_list == null:
		return

	_anim_list.clear()
	_edit_btn.disabled = true
	_save_btn.disabled = true
	_delete_btn.disabled = true
	
	_anim_list.add_item("Choose...")
	
	var animations = _manager.animations()
	var index: int = 1
	for id in animations:
		var anim = animations[id]
		_anim_list.add_item("%s (%s)" % [anim.name, anim.id])
		_anim_list.set_item_metadata(index, anim.id)
		
		if id == _opened_anim:
			_anim_list.select(index)
			_selected_anim = index
			_edit_btn.disabled = false
			_save_btn.disabled = false
			_delete_btn.disabled = false
		
		index += 1


func _on_NewAnimationDialog_form_validated(form) -> void:
	_opened_anim = form["id"]
	
	if form["edit"]:
		_manager.update_animation(AnimationData.new(form["id"], form["name"]))
	else:
		_manager.create_animation(AnimationData.new(form["id"], form["name"]))


func _on_AnimSelect_item_selected(index: int) -> void:
	if index > 0:
		_selected_anim = index
		_edit_btn.disabled = false
		_save_btn.disabled = false
		_delete_btn.disabled = false
	else:
		_selected_anim = -1
		_edit_btn.disabled = true
		_save_btn.disabled = true
		_delete_btn.disabled = true


func _on_CreateBtn_pressed() -> void:
	_main_ui.show_new_animation_dialog()


func _on_EditBtn_pressed() -> void:
	var anim = _manager.get_animation(_anim_list.get_item_metadata(_selected_anim))
	_main_ui.show_new_animation_dialog({"id": anim.id, "name": anim.name})


func _on_DeleteBtn_pressed() -> void:
	_main_ui.show_confirmation_dialog(
			"Delete animation", funcref(self, "delete_animation"))


func _on_SaveBtn_pressed() -> void:
	pass # Replace with function body.

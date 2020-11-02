tool
class_name AnimationsUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_anim: int = -1
var _opened_anim: AnimationData = null

onready var _manager = CardEngine.anim()
onready var _anim_list = $AnimationsLayout/Toolbar/AnimSelect
onready var _edit_btn = $AnimationsLayout/Toolbar/EditBtn
onready var _delete_btn = $AnimationsLayout/Toolbar/DeleteBtn
onready var _save_btn = $AnimationsLayout/Toolbar/SaveBtn
onready var _pos_seq = $AnimationsLayout/AnimEditLayout/PosSeqScroll/PosSeqLayout
onready var _scale_seq = $AnimationsLayout/AnimEditLayout/ScaleSeqScroll/ScaleSeqLayout
onready var _rot_seq = $AnimationsLayout/AnimEditLayout/RotSeqScroll/RotSeqLayout


func _ready():
	_manager.connect("changed", self, "_on_Animations_changed")


func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui


func delete_animation() -> void:
	if yield():
		_manager.delete_animation(_anim_list.get_item_metadata(_selected_anim))
		_select_anim(0)


func _select_anim(index: int) -> void:
	_anim_list.select(index)
	
	if index > 0:
		_selected_anim = index
		_opened_anim = _manager.get_animation(_anim_list.get_item_metadata(_selected_anim))
		_edit_btn.disabled = false
		_save_btn.disabled = false
		_delete_btn.disabled = false
		_load_animation()
	else:
		_selected_anim = -1
		_opened_anim = null
		_edit_btn.disabled = true
		_save_btn.disabled = true
		_delete_btn.disabled = true
		_clear_animation()


func _select_anim_by_id(id: String) -> void:
	for index in range(_anim_list.get_item_count()):
		if _anim_list.get_item_metadata(index) == id:
			_select_anim(index)
			return


func _load_animation() -> void:
	_clear_animation()
	
	var pos_steps = _opened_anim.position_seq()
	var scale_steps = _opened_anim.scale_seq()
	var rot_steps = _opened_anim.rotation_seq()
	
	if pos_steps.empty():
		var btn = Button.new()
		btn.text = "Initialize"
		_pos_seq.add_child(btn)
		btn.connect("pressed", self, "_on_InitBtn_pressed", ["pos"])
	else:
		var lbl = Label.new()
		lbl.text = "Steps count: %d" % pos_steps.size()
		_pos_seq.add_child(lbl)
	
	if scale_steps.empty():
		var btn = Button.new()
		btn.text = "Initialize"
		_scale_seq.add_child(btn)
		btn.connect("pressed", self, "_on_InitBtn_pressed", ["scale"])
	else:
		var lbl = Label.new()
		lbl.text = "Steps count: %d" % scale_steps.size()
		_pos_seq.add_child(lbl)
	
	if rot_steps.empty():
		var btn = Button.new()
		btn.text = "Initialize"
		_rot_seq.add_child(btn)
		btn.connect("pressed", self, "_on_InitBtn_pressed", ["rot"])
	else:
		var lbl = Label.new()
		lbl.text = "Steps count: %d" % rot_steps.size()
		_pos_seq.add_child(lbl)


func _clear_animation() -> void:
	Utils.delete_all_children(_pos_seq)
	Utils.delete_all_children(_scale_seq)
	Utils.delete_all_children(_rot_seq)


func _on_Animations_changed() -> void:
	if _anim_list == null:
		return

	_anim_list.clear()
	
	_anim_list.add_item("Choose...")
	_anim_list.set_item_disabled(0, true)
	_select_anim(0)
	
	var animations = _manager.animations()
	var index: int = 1
	for id in animations:
		var anim = animations[id]
		_anim_list.add_item("%s (%s)" % [anim.name, anim.id])
		_anim_list.set_item_metadata(index, anim.id)
		
		index += 1


func _on_NewAnimationDialog_form_validated(form) -> void:
	if form["edit"]:
		_opened_anim.name = form["name"]
		_manager.update_animation(_opened_anim)
	else:
		_manager.create_animation(AnimationData.new(form["id"], form["name"]))
	
	_select_anim_by_id(form["id"])


func _on_AnimSelect_item_selected(index: int) -> void:
	_select_anim(index)


func _on_CreateBtn_pressed() -> void:
	_main_ui.show_new_animation_dialog()


func _on_EditBtn_pressed() -> void:
	var anim = _manager.get_animation(_anim_list.get_item_metadata(_selected_anim))
	_main_ui.show_new_animation_dialog({"id": anim.id, "name": anim.name})


func _on_DeleteBtn_pressed() -> void:
	_main_ui.show_confirmation_dialog(
			"Delete animation", funcref(self, "delete_animation"))


func _on_SaveBtn_pressed() -> void:
	var id = _opened_anim.id
	_manager.update_animation(_opened_anim)
	_select_anim_by_id(id)

func _on_InitBtn_pressed(seq: String) -> void:
	match seq:
		"pos":
			_opened_anim.init_position_seq()
		"scale":
			_opened_anim.init_scale_seq()
		"rot":
			_opened_anim.init_rotation_seq()
		_:
			pass
	
	_load_animation()

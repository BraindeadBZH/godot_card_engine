tool
class_name AnimationsUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_anim: int = -1
var _opened_anim: AnimationData = null
var _anim_block: AnimationBlock = null

onready var _manager = CardEngine.anim()
onready var _anim_list = $AnimationsLayout/Toolbar/AnimSelect
onready var _edit_btn = $AnimationsLayout/Toolbar/EditBtn
onready var _delete_btn = $AnimationsLayout/Toolbar/DeleteBtn
onready var _save_btn = $AnimationsLayout/Toolbar/SaveBtn
onready var _reset_btn = $AnimationsLayout/Toolbar/ResetBtn
onready var _preview_btn = $AnimationsLayout/Toolbar/PreviewBtn
onready var _idle_btn = $AnimationsLayout/AnimChainLayout/IdleBtn
onready var _focused_btn = $AnimationsLayout/AnimChainLayout/FocusedBtn
onready var _activated_btn = $AnimationsLayout/AnimChainLayout/ActivatedBtn
onready var _deactivated_btn = $AnimationsLayout/AnimChainLayout/DeactivatedBtn
onready var _unfocused_btn = $AnimationsLayout/AnimChainLayout/UnfocusedBtn
onready var _pos_seq = $AnimationsLayout/AnimEditLayout/SeqLayout/PosSeqContainer/PosSeqScroll/PosSeqLayout
onready var _pos_seq_tools = $AnimationsLayout/AnimEditLayout/SeqLayout/PosSeqContainer/PosSeqToolsLayout
onready var _scale_seq = $AnimationsLayout/AnimEditLayout/SeqLayout/ScaleSeqContainer/ScaleSeqScroll/ScaleSeqLayout
onready var _scale_seq_tools = $AnimationsLayout/AnimEditLayout/SeqLayout/ScaleSeqContainer/ScaleSeqToolsLayout
onready var _rot_seq = $AnimationsLayout/AnimEditLayout/SeqLayout/RotSeqContainer/RotSeqScroll/RotSeqLayout
onready var _rot_seq_tools = $AnimationsLayout/AnimEditLayout/SeqLayout/RotSeqContainer/RotSeqToolsLayout


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

	_idle_btn.pressed = false
	_focused_btn.pressed = false
	_activated_btn.pressed = false
	_deactivated_btn.pressed = false
	_unfocused_btn.pressed = false

	if index > 0:
		_selected_anim = index
		_opened_anim = _manager.get_animation(
			_anim_list.get_item_metadata(_selected_anim))
		_anim_block = null
		_edit_btn.disabled = false
		_save_btn.disabled = false
		_reset_btn.disabled = false
		_delete_btn.disabled = false
		_preview_btn.disabled = false
		_idle_btn.disabled = false
		_focused_btn.disabled = false
		_activated_btn.disabled = false
		_deactivated_btn.disabled = false
		_unfocused_btn.disabled = false
		_load_animation()
	else:
		_selected_anim = -1
		_opened_anim = null
		_anim_block = null
		_edit_btn.disabled = true
		_save_btn.disabled = true
		_reset_btn.disabled = true
		_delete_btn.disabled = true
		_preview_btn.disabled = true
		_idle_btn.disabled = true
		_focused_btn.disabled = true
		_activated_btn.disabled = true
		_deactivated_btn.disabled = true
		_unfocused_btn.disabled = true
		_clear_animation()


func _select_anim_by_id(id: String) -> void:
	for index in range(_anim_list.get_item_count()):
		if _anim_list.get_item_metadata(index) == id:
			_select_anim(index)
			return


func _load_animation() -> void:
	_clear_animation()

	if _anim_block == null:
		return

	_load_sequence(_anim_block.position_sequence(), _pos_seq, _pos_seq_tools)
	_load_sequence(_anim_block.scale_sequence(), _scale_seq, _scale_seq_tools)
	_load_sequence(_anim_block.rotation_sequence(), _rot_seq, _rot_seq_tools)


func _load_sequence(seq: AnimationSequence, layout: Control, tools: Control) -> void:
	if seq.empty():
		var btn = Button.new()
		btn.text = "Initialize"
		tools.add_child(btn)
		btn.connect("pressed", self, "_on_InitBtn_pressed", [seq])
	else:
		var add_btn = Button.new()
		add_btn.text = "Add step"
		add_btn.hint_tooltip = "Insert a step before the last step"
		tools.add_child(add_btn)
		add_btn.connect("pressed", self, "_on_AddStepBtn_pressed", [seq])

		var clear_btn = Button.new()
		clear_btn.text = "Clear sequence"
		clear_btn.hint_tooltip = "Remove all the steps"
		tools.add_child(clear_btn)
		clear_btn.connect("pressed", self, "_on_ClearSeqBtn_pressed", [seq])

		var index := 0
		for step in seq.sequence():
			var step_layout = HBoxContainer.new()
			var step_lbl = Label.new()
			step_lbl.text = "%d >" % index
			step_layout.add_child(step_lbl)

			var is_last = index == seq.length()-1

			if step.transi != null:
				var btn = Button.new()
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				if step.transi.random_duration:
					btn.text = "rand(%dms, %dms) %s %s" % [
						step.transi.duration_range_min * 1000.0,
						step.transi.duration_range_max * 1000.0,
						_transi_type_display(step.transi.type),
						_transi_easing_display(step.transi.easing)]
				else:
					btn.text = "%dms %s %s" % [
						step.transi.duration * 1000.0,
						_transi_type_display(step.transi.type),
						_transi_easing_display(step.transi.easing)]
				btn.disabled = not step.editable_transi
				btn.hint_tooltip = "Edit step transition"
				step_layout.add_child(btn)
				btn.connect("pressed", self, "_on_TransiBtn_pressed", [seq, index])

			var initial_txt = "initial(%s)"
			if index == 0:
				initial_txt = initial_txt % _initial_mode_display(seq.from_mode())
			else:
				initial_txt = initial_txt % _initial_mode_display(seq.to_mode())

			if step.val != null:
				var btn = Button.new()
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				if seq is PositionSequence:
					match step.val.mode:
						StepValue.Mode.INITIAL:
							btn.text = initial_txt
						StepValue.Mode.FIXED:
							btn.text = "(%.2f, %.2f)" % [
								step.val.vec_val.x,
								step.val.vec_val.y]
						StepValue.Mode.RANDOM:
							btn.text = "rand(%.2f to %.2f, %.2f to %.2f)" % [
								step.val.vec_val.x,
								step.val.vec_range.x,
								step.val.vec_val.y,
								step.val.vec_range.y]
				elif seq is ScaleSequence:
					match step.val.mode:
						StepValue.Mode.INITIAL:
							btn.text = initial_txt
						StepValue.Mode.FIXED:
							btn.text = "(%.2f, %.2f)" % [
								step.val.vec_val.x,
								step.val.vec_val.y]
						StepValue.Mode.RANDOM:
							btn.text = "rand(%.2f to %.2f, %.2f to %.2f)" % [
								step.val.vec_val.x,
								step.val.vec_range.x,
								step.val.vec_val.y,
								step.val.vec_range.y]
				elif seq is RotationSequence:
					match step.val.mode:
						StepValue.Mode.INITIAL:
							btn.text = initial_txt
						StepValue.Mode.FIXED:
							btn.text = "%.2f°" % step.val.num_val
						StepValue.Mode.RANDOM:
							btn.text = "rand(%.2f° to %.2f°)" % [
								step.val.num_val,
								step.val.num_range]
				btn.disabled = not step.editable_val
				btn.hint_tooltip = "Edit step value"
				step_layout.add_child(btn)
				btn.connect("pressed", self, "_on_ValueBtn_pressed", [seq, index])

			var prev_step := seq.step(index-1)
			var next_step := seq.step(index+1)

			var up_btn = Button.new()
			up_btn.text = "▲"
			up_btn.hint_tooltip = "Move up"
			step_layout.add_child(up_btn)
			up_btn.connect("pressed", self, "_on_UpBtn_pressed", [seq, index])

			if not(step.editable_transi and step.editable_val) or index < 1:
					up_btn.disabled = true

			if prev_step != null and not(prev_step.editable_transi and prev_step.editable_val):
					up_btn.disabled = true

			var down_btn = Button.new()
			down_btn.text = "▼"
			down_btn.hint_tooltip = "Move down"
			step_layout.add_child(down_btn)
			down_btn.connect("pressed", self, "_on_DownBtn_pressed", [seq, index])

			if not(step.editable_transi and step.editable_val) or index >= seq.length()-1:
					down_btn.disabled = true

			if next_step != null and not(next_step.editable_transi and next_step.editable_val):
				down_btn.disabled = true

			var dup_btn = Button.new()
			dup_btn.text = "D"
			dup_btn.hint_tooltip = "Duplicate step"
			step_layout.add_child(dup_btn)
			dup_btn.connect("pressed", self, "_on_DupBtn_pressed", [seq, step])

			if not(step.editable_transi and step.editable_val):
					dup_btn.disabled = true

			var del_btn = Button.new()
			del_btn.text = "X"
			del_btn.hint_tooltip = "Delete step"
			step_layout.add_child(del_btn)
			del_btn.connect("pressed", self, "_on_DelStepBtn_pressed", [seq, index])

			if not(step.editable_transi and step.editable_val):
				del_btn.disabled = true

			layout.add_child(step_layout)
			index += 1


func _clear_animation() -> void:
	Utils.delete_all_children(_pos_seq_tools)
	Utils.delete_all_children(_pos_seq)
	Utils.delete_all_children(_scale_seq_tools)
	Utils.delete_all_children(_scale_seq)
	Utils.delete_all_children(_rot_seq_tools)
	Utils.delete_all_children(_rot_seq)


func _transi_type_display(type: int) -> String:
	match type:
		Tween.TRANS_LINEAR:
			return "Linear"
		Tween.TRANS_SINE:
			return "Sine"
		Tween.TRANS_QUINT:
			return "Quint"
		Tween.TRANS_QUART:
			return "Quart"
		Tween.TRANS_QUAD:
			return "Quad"
		Tween.TRANS_EXPO:
			return "Expo"
		Tween.TRANS_ELASTIC:
			return "Elastic"
		Tween.TRANS_CUBIC:
			return "Cubic"
		Tween.TRANS_CIRC:
			return "Circ"
		Tween.TRANS_BOUNCE:
			return "Bounce"
		Tween.TRANS_BACK:
			return "Back"
		_:
			return "None"


func _transi_easing_display(easing: int) -> String:
	match easing:
		Tween.EASE_IN:
			return "In"
		Tween.EASE_OUT:
			return "Out"
		Tween.EASE_IN_OUT:
			return "In/Out"
		Tween.EASE_OUT_IN:
			return "Out/In"
		_:
			return "None"


func _val_mode_display(mode: int) -> String:
	match mode:
		StepValue.Mode.INITIAL:
			return "Initial"
		StepValue.Mode.FIXED:
			return "Fixed"
		StepValue.Mode.RANDOM:
			return "Random"
		_:
			return "None"


func _initial_mode_display(mode: int) -> String:
	match mode:
		AnimationSequence.INIT_DISABLED:
			return "none"
		AnimationSequence.INIT_ORIGIN:
			return "origin"
		AnimationSequence.INIT_FOCUSED:
			return "focused"
		AnimationSequence.INIT_ACTIVATED:
			return "activated"
		_:
			return "none"


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


func _on_ResetBtn_pressed() -> void:
	_opened_anim = _manager.reset_animation(_opened_anim)

	if _idle_btn.pressed:
		_anim_block = _opened_anim.idle_loop()
	elif _focused_btn.pressed:
		_anim_block = _opened_anim.focused_animation()
	elif _activated_btn.pressed:
		_anim_block = _opened_anim.activated_animation()
	elif _deactivated_btn.pressed:
		_anim_block = _opened_anim.deactivated_animation()
	elif _unfocused_btn.pressed:
		_anim_block = _opened_anim.unfocused_animation()

	_load_animation()


func _on_PreviewBtn_pressed() -> void:
	_main_ui.show_preview_dialog(_opened_anim)


func _on_IdleBtn_pressed() -> void:
	if _opened_anim == null:
		return

	_idle_btn.pressed = true
	_focused_btn.pressed = false
	_activated_btn.pressed = false
	_deactivated_btn.pressed = false
	_unfocused_btn.pressed = false

	_anim_block = _opened_anim.idle_loop()
	_load_animation()


func _on_FocusedBtn_pressed() -> void:
	if _opened_anim == null:
		return

	_idle_btn.pressed = false
	_focused_btn.pressed = true
	_activated_btn.pressed = false
	_deactivated_btn.pressed = false
	_unfocused_btn.pressed = false

	_anim_block = _opened_anim.focused_animation()
	_load_animation()


func _on_ActivatedBtn_pressed() -> void:
	if _opened_anim == null:
		return

	_idle_btn.pressed = false
	_focused_btn.pressed = false
	_activated_btn.pressed = true
	_deactivated_btn.pressed = false
	_unfocused_btn.pressed = false

	_anim_block = _opened_anim.activated_animation()
	_load_animation()


func _on_DeactivatedBtn_pressed() -> void:
	if _opened_anim == null:
		return

	_idle_btn.pressed = false
	_focused_btn.pressed = false
	_activated_btn.pressed = false
	_deactivated_btn.pressed = true
	_unfocused_btn.pressed = false

	_anim_block = _opened_anim.deactivated_animation()
	_load_animation()


func _on_UnfocusedBtn_pressed() -> void:
	if _opened_anim == null:
		return

	_idle_btn.pressed = false
	_focused_btn.pressed = false
	_activated_btn.pressed = false
	_deactivated_btn.pressed = false
	_unfocused_btn.pressed = true

	_anim_block = _opened_anim.unfocused_animation()
	_load_animation()


func _on_InitBtn_pressed(seq: AnimationSequence) -> void:
	seq.init_sequence()
	_load_animation()


func _on_AddStepBtn_pressed(seq: AnimationSequence) -> void:
	seq.add_step(null, true)
	_load_animation()


func _on_ClearSeqBtn_pressed(seq: AnimationSequence) -> void:
	seq.clear_sequence()
	_load_animation()


func _on_DelStepBtn_pressed(seq: AnimationSequence, idx: int) -> void:
	seq.remove_step(idx)
	_load_animation()


func _on_UpBtn_pressed(seq: AnimationSequence, idx: int) -> void:
	seq.shift_step_left(idx)
	_load_animation()


func _on_DownBtn_pressed(seq: AnimationSequence, idx: int) -> void:
	seq.shift_step_right(idx)
	_load_animation()


func _on_DupBtn_pressed(seq: AnimationSequence, step: AnimationStep) -> void:
	seq.add_step(step.duplicate(), true)
	_load_animation()


func _on_TransiBtn_pressed(seq: AnimationSequence, idx: int) -> void:
	var data := {}

	data["seq"] = seq
	data["index"] = idx
	data["random_duration"] = seq.step(idx).transi.random_duration
	data["duration"] = seq.step(idx).transi.duration
	data["duration_range_min"] = seq.step(idx).transi.duration_range_min
	data["duration_range_max"] = seq.step(idx).transi.duration_range_max
	data["type"] = seq.step(idx).transi.type
	data["easing"] = seq.step(idx).transi.easing
	data["flip_card"] = seq.step(idx).transi.flip_card
	data["interactive"] = seq.step(idx).transi.interactive

	_main_ui.show_step_transi_dialog(data)


func _on_StepTransiDialog_form_validated(form) -> void:
	var seq: AnimationSequence = form["seq"]
	var idx: int = form["index"]

	if seq == null:
		return

	seq.step(idx).transi.random_duration = form["random_duration"]
	seq.step(idx).transi.duration = form["duration"]
	seq.step(idx).transi.duration_range_min = form["duration_range_min"]
	seq.step(idx).transi.duration_range_max = form["duration_range_max"]
	seq.step(idx).transi.type = form["type"]
	seq.step(idx).transi.easing = form["easing"]
	seq.step(idx).transi.flip_card = form["flip_card"]
	seq.step(idx).transi.interactive = form["interactive"]

	_load_animation()


func _on_ValueBtn_pressed(seq: AnimationSequence, idx: int) -> void:
	var data := {}

	data["seq"] = seq
	data["index"] = idx

	if seq is RotationSequence:
		data["mode"] = seq.step(idx).val.mode
		data["value"] = seq.step(idx).val.num_val
		data["range"] = seq.step(idx).val.num_range
	else:
		data["mode"] = seq.step(idx).val.mode
		data["value"] = seq.step(idx).val.vec_val
		data["range"] = seq.step(idx).val.vec_range

	_main_ui.show_step_value_dialog(data)


func _on_StepValueDialog_form_validated(form) -> void:
	var seq: AnimationSequence = form["seq"]
	var idx: int = form["index"]

	if seq == null:
		return

	if seq is RotationSequence:
		seq.step(idx).val.mode = form["mode"]
		seq.step(idx).val.num_val = form["value"]
		seq.step(idx).val.num_range = form["range"]
	else:
		seq.step(idx).val.mode = form["mode"]
		seq.step(idx).val.vec_val = form["value"]
		seq.step(idx).val.vec_range = form["range"]

	_load_animation()

tool
class_name EffectsUi
extends Control

var _main_ui: CardEngineUI = null
var _selected_fx: int = -1

onready var _manager = CardEngine.fx()
onready var _fx_list = $EffectLayout/EffectList
onready var _edit_btn = $EffectLayout/Toolbar/EditBtn
onready var _delete_btn = $EffectLayout/Toolbar/DeleteBtn


func _ready():
	_manager.connect("changed", self, "_on_Effects_changed")


func set_main_ui(ui: CardEngineUI) -> void:
	_main_ui = ui


func delete_effect() -> void:
	if yield():
		_manager.delete_effect(_fx_list.get_item_metadata(_selected_fx))


func _on_Databases_changed() -> void:
	if _fx_list == null:
		return

	_fx_list.clear()
	_edit_btn.disabled = true
	_delete_btn.disabled = true

	var fxs = _manager.effects()
	for id in fxs:
		pass # TODO


func _on_Effects_changed() -> void:
	if _fx_list == null:
		return

	_fx_list.clear()
	_edit_btn.disabled = true
	_delete_btn.disabled = true

	var effects = _manager.effects()
	for id in effects:
		var fx = effects[id]
		_fx_list.add_item("%s: %s" % [fx.id, fx.name])
		_fx_list.set_item_metadata(_fx_list.get_item_count()-1, fx.id)


func _on_NewEffectDialog_form_validated(form) -> void:
	if form["edit"]:
		_manager.update_effect(form["id"], form["name"])
	else:
		_manager.create_effect(form["id"], form["name"])


func _on_CreateBtn_pressed() -> void:
	_main_ui.show_new_effect_dialog()


func _on_EffectList_item_selected(index: int) -> void:
	_selected_fx = index
	_edit_btn.disabled = false
	_delete_btn.disabled = false


func _on_EditBtn_pressed() -> void:
	_manager.edit(_fx_list.get_item_metadata(_selected_fx))


func _on_DeleteBtn_pressed() -> void:
	_main_ui.show_confirmation_dialog(
			"Delete effect", funcref(self, "delete_effect"))


func _on_EffectList_item_activated(index: int) -> void:
	var fx = _manager.get_effect(_fx_list.get_item_metadata(_selected_fx))
	_main_ui.show_new_effect_dialog({"id": fx.id, "name": fx.name})

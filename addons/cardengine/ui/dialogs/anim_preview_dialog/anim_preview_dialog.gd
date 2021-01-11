tool
class_name AnimPreviewDialog
extends WindowDialog

var _anim: AnimationData = null

onready var _preview_card = $Center/PreviewCard


func show_anim(anim: AnimationData) -> void:
	_anim = anim
	popup_centered()


func _on_AnimPreviewDialog_about_to_show() -> void:
	_preview_card.set_root_trans_immediate(CardTransform.new())
	_preview_card.set_animation(_anim)
	_preview_card.set_instance(CardInstance.new(CardData.new("preview", "preview")))


func _on_AnimPreviewDialog_popup_hide() -> void:
	_preview_card.set_animation(null)

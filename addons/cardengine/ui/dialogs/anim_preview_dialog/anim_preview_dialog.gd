tool
class_name AnimPreviewDialog
extends WindowDialog

var _anim: AnimationData = null

onready var _preview_card: AbstractCard = $Center/PreviewCard


func show_anim(anim: AnimationData) -> void:
	_anim = anim
	popup_centered()


func _on_AnimPreviewDialog_about_to_show() -> void:
	_preview_card.set_root_trans_immediate(CardTransform.new())
	_preview_card.change_anim(_anim, true)


func _on_AnimPreviewDialog_popup_hide() -> void:
	_preview_card.change_anim(null)

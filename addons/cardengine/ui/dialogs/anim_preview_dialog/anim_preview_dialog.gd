tool
class_name AnimPreviewDialog
extends WindowDialog

var _anim: AnimationData = null

onready var _anim_player: Tween = $AnimPlayer
onready var _preview_card: AbstractCard = $Center/PreviewCard


func show_anim(anim: AnimationData) -> void:
	_anim = anim
	popup_centered()


func _on_AnimPreviewDialog_about_to_show() -> void:
	_preview_card.set_root_trans_immediate(CardTransform.new())
	
	_anim.setup_for(_anim_player, _preview_card)
	_anim_player.start()


func _on_AnimPreviewDialog_popup_hide() -> void:
	_anim_player.stop_all()
	_anim_player.remove_all()

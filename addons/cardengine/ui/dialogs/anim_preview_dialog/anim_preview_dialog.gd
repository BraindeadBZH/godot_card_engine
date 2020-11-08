tool
class_name AnimPreviewDialog
extends WindowDialog

var _anim: AnimationData = null

onready var _anim_player: Tween = $AnimPlayer
onready var _preview_card: Node2D = $Center/PreviewCard


func show_anim(anim: AnimationData) -> void:
	_anim = anim
	popup_centered()


func _on_AnimPreviewDialog_about_to_show() -> void:
	_preview_card.position = Vector2(0.0, 0.0)
	_preview_card.scale = Vector2(1.0, 1.0)
	_preview_card.rotation = 0
	
	_anim.setup_for(_anim_player, _preview_card)
	_anim_player.start()


func _on_AnimPreviewDialog_popup_hide() -> void:
	_anim_player.stop_all()
	_anim_player.remove_all()

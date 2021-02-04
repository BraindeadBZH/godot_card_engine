class_name Board
extends AbstractBoard

var _register: Dictionary = {}
var _cards: Node2D = null


func _ready() -> void:
	_cards = Node2D.new()
	add_child(_cards)

	_check_for_containers()


func register_card(cont: AbstractContainer, card: AbstractCard) -> void:
	VisualServer.canvas_item_set_parent(card.get_canvas_item(), _cards.get_canvas_item())
	card.connect("transform_changed", self, "_on_card_transform_changed", [card, cont], CONNECT_DEFERRED)


func register_last_known_transform(ref: int, trans: CardTransform) -> void:
	_register[ref] = trans


func get_last_known_transform(ref: int) -> CardTransform:
	if not _register.has(ref):
		return null
	else:
		return _register[ref]


func _check_for_containers() -> void:
	for child in get_children():
		if child is AbstractContainer:
			child.set_board(self)


func _on_card_transform_changed(card: AbstractCard, cont: AbstractContainer) -> void:
	VisualServer.canvas_item_set_transform(
		card.get_canvas_item(), cont.get_transform() * card.get_transform())

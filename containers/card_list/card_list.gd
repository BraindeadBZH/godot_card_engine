class_name CardList
extends CardListPrivate
# Public class for CardList

func _card_clicked(card: AbstractCard) -> void:
	card.flip()

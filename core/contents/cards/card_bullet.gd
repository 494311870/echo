extends Card

func can_pass(other_card: Card) -> bool:
	return true


func interact(other_card: Card)-> void:
	if other_card.has_meta("weapon"):
		other_card.set_meta("weapon", 1)
		other_card.refresh()

	mark_resolved()


extends Card

func can_pass(other_card: Card) -> bool:
	return false


func interact(other_card: Card)-> void:
	var weapon = other_card.get_meta("weapon", 0)
	if weapon == 0:
		view.get_tree().call_group("main_handler", "game_over")
		return

	other_card.set_meta("weapon", 0)
	other_card.refresh()
	mark_resolved()

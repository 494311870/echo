extends Card

func can_pass(other_card: Card) -> bool:
	return true


func interact(other_card: Card)-> void:
	if other_card.get_meta("weapon", 0) > 0:
		view.get_tree().call_group("main_handler", "game_over")
		return

	mark_resolved()

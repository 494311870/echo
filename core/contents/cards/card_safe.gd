extends Card

func can_pass(other_card: Card) -> bool:
	return false


func interact(other_card: Card)-> void:
	var key = other_card.get_meta("key", 0)
	if key == 0:
		view.get_tree().call_group("main_handler", "game_over")
		return

	key -= 1
	other_card.set_meta("key", key)
	other_card.refresh()
	mark_resolved()

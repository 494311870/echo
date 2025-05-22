extends Card

func interact(other_card: Card)-> void:
	# check key
#	var key = other_card.get_meta("key", 0)
#	if key == 0:
#		view.get_tree().call_group("main_handler", "game_over")
#		return
#
#	key -= 1
#	other_card.set_meta("key", key)
#	other_card.refresh()
	# enter the exit
	var cards          = view.get_tree().get_nodes_in_group("cards")
	var remains: Array = cards.filter(func(card: CardView): return not card.is_resolved())
	print("Exit：", remains)

	view.get_tree().call_group("main_handler", "continue_explore")

	if remains.size() == 2:
		print("next level")
		view.get_tree().call_group("level_handler", "next_level")

		

extends Card

var _is_killed: bool = false


func can_pass(other_card: Card) -> bool:
	return _is_killed


func interact(other_card: Card)-> void:
	if _is_killed:
		mark_resolved()
		return

	var weapon = other_card.get_meta("weapon", 0)
	if weapon == 0:
		view.get_tree().call_group("main_handler", "game_over")
		return

	other_card.set_meta("weapon", 0)
	other_card.refresh()
	_is_killed = true
#	view.change_art(_art_open)

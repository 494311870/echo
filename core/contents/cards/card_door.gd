extends Card

@export var _art_open: Texture2D

var _is_open: bool = false


func can_pass(other_card: Card) -> bool:
	return _is_open


func interact(other_card: Card)-> void:
	if _is_open:
		mark_resolved()
		return

	var key = other_card.get_meta("key", 0)
	if key == 0:
		view.get_tree().call_group("main_handler", "game_over")
		return

	key -= 1
	other_card.set_meta("key", key)
	_is_open = true
	view.change_art(_art_open)
		
	

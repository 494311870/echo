extends Card

func can_pass(other_card: Card) -> bool:
	return true


func interact(other_card: Card)-> void:
	var key = other_card.get_meta("key", 0)
	key += 1
	other_card.set_meta("key", key)
	mark_resolved()
	

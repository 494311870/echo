class_name Level
extends Resource

@export var reference_level: Level
@export var cards: Array[Card] = []


func get_cards() -> Array[Card]:
	if not reference_level:
		return cards

	return reference_level.get_cards() + cards
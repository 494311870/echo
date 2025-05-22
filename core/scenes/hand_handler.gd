extends Node

@export var _hand_slots: Control
@export var _card_view_prefab: PackedScene
@export var _deck_position : Marker2D

var _slots: Array[CardSlot] = []


func _ready() -> void:
	_slots.assign(_hand_slots.get_children())


func _draw_cards() -> void:
	var level: Level       = owner.get_meta("level")
	var cards: Array[Card] = level.cards

	for i in range(cards.size()):
		var card: Card     = cards[i]
		var slot: CardSlot = _slots[i % _slots.size()]

		var card_view: CardView = _card_view_prefab.instantiate()
		card_view.card = card.duplicate()
		slot.add_card(card_view)
		card_view.global_position = _deck_position.global_position
		
		card_view.move_to(slot.global_position)
		await get_tree().create_timer(0.2).timeout
		
		

	

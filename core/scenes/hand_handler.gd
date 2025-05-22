extends Node

@export var _run_button: Control
@export var _hand_slots: Control
@export var _card_view_prefab: PackedScene
@export var _deck_position: Marker2D

var _slots: Array[CardSlot] = []


func _ready() -> void:
	_slots.assign(_hand_slots.get_children())

	for slot: CardSlot in _slots:
		slot.child_order_changed.connect(_slot_on_child_order_changed)


func _slot_on_child_order_changed() -> void:
	var has_hand: bool = _slots.any(func (x: CardSlot): return x.get_top_card() != null)
	_run_button.visible = not has_hand


func _draw_cards() -> void:
	var level: Level       = owner.get_meta("level")
	var cards: Array[Card] = level.get_cards()

	for i in range(cards.size()):
		var card: Card     = cards[i]
		var slot: CardSlot = _slots[i % _slots.size()]

		var card_view: CardView = _card_view_prefab.instantiate()
		card_view.card = card.duplicate()
		slot.add_card(card_view)
		card_view.global_position = _deck_position.global_position

		card_view.move_to(slot.global_position)
		await get_tree().create_timer(0.2).timeout
		
		

	

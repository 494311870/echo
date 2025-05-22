class_name CardSlot
extends Control

@export var is_locked: bool

var _initial_card: CardView


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_child_count() > 0:
		_initial_card = get_child(0) as CardView
		_initial_card.is_locked = is_locked


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if is_locked:
		return false

	if data == null:
		return false
	if not data.has("item"):
		return false

	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var drop_item: CardView   = data.item
	var origin_slot: CardSlot = drop_item.get_parent() as CardSlot
	var target_slot: CardSlot = self
	var target_position       = at_position - data.offset

	if origin_slot == target_slot:
		return

	if drop_item.get_parent() != self:
		drop_item.reparent(self)

	drop_item.position = Vector2.ZERO


func get_top_card() -> CardView:
	if get_child_count() == 0:
		return null

	return get_children()[-1] as CardView


func add_card(card_view: CardView) -> void:
	add_child(card_view)


func move_card(card_view: CardView)-> void:
	if card_view.get_parent() != self:
		card_view.reparent(self)


func clear() -> void:
	for child in get_children():
		child.queue_free()

		
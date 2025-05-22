extends Node

@export var _run_slots: Control

var _slots: Array[CardSlot] = []
var _player: CardView


func _ready() -> void:
	_slots.assign(_run_slots.get_children())

	var start_slot: CardSlot = _slots[0]
	_player = start_slot.get_top_card()
	_player.z_index = 10


func _run() -> void:
	print("run...")
	_move_to_next()


func _move_to_next() -> void:
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	var current_slot_index     = _slots.find(current_slot)

	var next_slot_index: int = current_slot_index + 1
	if next_slot_index >= _slots.size():
		next_slot_index = 0

	var next_slot: CardSlot = _slots[next_slot_index]
	var next_card: CardView = next_slot.get_top_card()

	if not next_card:
		await _player.move_with_shake(next_slot.global_position)
		next_slot.move_card(_player)
	elif next_card.can_pass(_player):
		await _player.move_with_shake(next_slot.global_position)
		next_slot.move_card(_player)
		_player.interact(next_card)
	else:
		var source_position: Vector2 = _player.global_position
		var half_position: Vector2   = next_slot.global_position - Vector2(next_slot.size.x / 2, 0)
		await _player.move_with_shake(half_position)
		_player.interact(next_card)
		await _player.move_with_shake(source_position)


func game_over() -> void:
	print("game over")
	get_tree().reload_current_scene()
	
		
	
	
	
	
	

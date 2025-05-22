extends Node

@export var _run_slots: Control
@export var _player_info: PlayerInfo
@export var _player_card: Card

var _slots: Array[CardSlot] = []
var _player: CardView
var _exit_room: CardView


func _ready() -> void:
	_slots.assign(_run_slots.get_children())

	var start_slot: CardSlot = _slots[0]
	_player = start_slot.get_top_card()
	_player.z_index = 10

	var end_slot: CardSlot = _slots[-1]
	_exit_room = end_slot.get_top_card()

	_set_up_player()


func _set_up_player() -> void:
	var player_card = _player_card.duplicate()
	_player.card = player_card
	_player_info.player = player_card


func _run() -> void:
	print("run...")
	_move_to_next()


func _move_to_next() -> void:
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	var current_slot_index     = _slots.find(current_slot)
	var next_slot_index: int = current_slot_index + _player.direction

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
		var offset = Vector2(next_slot.size.x / 2, 0) * _player.direction
		var half_position: Vector2   = next_slot.global_position - offset
		await _player.move_with_shake(half_position)
		_player.interact(next_card)
		await _player.move_with_shake(source_position)


func _reset_status() -> void:
	_set_up_player()

	
#func _reset_scene() -> void:
#	var start_slot: CardSlot = _slots[0]
#	start_slot.move_card(_player)
#	_player.position = Vector2.ZERO
#	var end_slot: CardSlot = _slots[-1]
#	end_slot.move_card(_exit_room)
#	_exit_room.position = Vector2.ZERO


func game_over() -> void:
	await get_tree().create_timer(0.5).timeout
	print("game over")
	get_tree().reload_current_scene()


func continue_explore() -> void:
	_player.flip()
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	var current_slot_index     = _slots.find(current_slot)
	if current_slot_index == 0:
		var end_slot: CardSlot = _slots[-1]
		end_slot.move_card(_exit_room)
		_exit_room.position = Vector2.ZERO
	else:
		var start_slot: CardSlot = _slots[0]
		start_slot.move_card(_exit_room)
		_exit_room.position = Vector2.ZERO
		
		

extends Node

signal level_restarted
@export var _run_button: Control
@export var _run_slots: Control
@export var _player_info: PlayerInfo
@export var _player_card: Card
@export var _art_player_fail: Texture2D


var _slots: Array[CardSlot]           = []
var _available_slots: Array[CardSlot] = []
var _player: CardView
var _exit_room: CardView
var _is_playing: bool
var _starting_point: int              = 0


func _ready() -> void:
	_slots.assign(_run_slots.get_children())
	_available_slots.assign(_slots.slice(1, -1))

	for slot: CardSlot in _available_slots:
		slot.child_order_changed.connect(_slot_on_child_order_changed)

	# set up 
	var start_slot: CardSlot = _slots[0]
	_player = start_slot.get_top_card()
	_player.z_index = 10
	var end_slot: CardSlot   = _slots[-1]
	_exit_room = end_slot.get_top_card()

	_set_up_player()


func _slot_on_child_order_changed()-> void:
	if _is_playing:
		return

	var is_full: bool = _available_slots.all(
							func (x: CardSlot): return x.get_top_card() != null)
	if not is_full:
		return

	if _run_button.visible == true:
		return

	for slot: CardSlot in _available_slots:
		slot.flip_top_card.call_deferred()


func _set_up_player() -> void:
	var player_card = _player_card.duplicate()
	_player.card = player_card
	_player_info.player = player_card


func _reset_scene() -> void:
	_set_up_player()
	_reset_player(_starting_point)
	_reset_exit_room(_starting_point)
	_clear_slots()
	level_restarted.emit()


func _clear_slots() -> void:
	for i in range(1, _slots.size() - 1):
		var slot: CardSlot = _slots[i]
		slot.clear()


func _reset_player(player_index: int) -> void:
	print("_reset_player：", player_index)
	var slot: CardSlot = _slots[player_index]
	slot.move_card(_player)
	_player.position = Vector2.ZERO

	if player_index == 0 and _player.direction == -1:
		_player.flip_visuals()
	elif player_index != 0 and _player.direction == 1:
		_player.flip_visuals()


func _reset_exit_room(player_index: int) -> void:
	if player_index == 0:
		var end_slot: CardSlot = _slots[-1]
		end_slot.move_card(_exit_room)
		_exit_room.position = Vector2.ZERO
	else:
		var start_slot: CardSlot = _slots[0]
		start_slot.move_card(_exit_room)
		_exit_room.position = Vector2.ZERO


func _run() -> void:
	_run_button.visible = false
	if _is_playing:
		return
	print("run...")
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	_starting_point    = _slots.find(current_slot)

	_is_playing = true
	_auto_move()


func _auto_move() -> void:
	await _move_to_next()
	await get_tree().create_timer(0.1).timeout
	if _is_playing:
		_auto_move()


func _move_to_next() -> void:
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	var current_slot_index     = _slots.find(current_slot)
	var next_slot_index: int   = current_slot_index + _player.direction

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
		var card_interactive: Card   = next_card.card
		var source_position: Vector2 = _player.global_position
		var offset                   = Vector2(next_slot.size.x / 2, 0) * _player.direction
		var half_position: Vector2   = next_slot.global_position - offset
		await _player.move_with_shake(half_position)
		_player.interact(next_card)
		await _player.move_with_shake(source_position)

		# 需要翻开底下的卡牌
		if card_interactive.is_resolved and card_interactive.flip_bottom:
			next_slot.flip_top_card()


func _reset_status() -> void:
	_is_playing = false
	_set_up_player()


func game_over() -> void:
	_is_playing = false
	_player.change_art(_art_player_fail)
	await get_tree().create_timer(1.0).timeout
	print("game over")
	_reset_scene()


func continue_explore() -> void:
	_player.flip_visuals()
	var current_slot: CardSlot = _player.get_parent() as CardSlot
	var current_slot_index     = _slots.find(current_slot)
	_reset_exit_room(current_slot_index)

	for slot in _available_slots:
		# 如果仍然有卡牌在桌面上，保留
		if slot.get_top_card():
			continue

		slot.flip_top_card.call_deferred()
		
		

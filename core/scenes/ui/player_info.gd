class_name PlayerInfo
extends Control

@export var player: Card: set = _set_player

@onready var _keys: Control = %Keys
@onready var _weapon: Control = %Weapon


func _ready() -> void:
	_weapon.visible = false
	_keys.get_children().map(func (x): x.visible = false)


func _set_player(value: Card) -> void:
	if player:
		player.refresh_requested.disconnect(_refresh_info)

	player = value

	if not is_node_ready():
		await ready

	if not player:
		return

	player.refresh_requested.connect(_refresh_info)

	_refresh_info()


func _refresh_info()-> void:
	_weapon.visible = player.has_meta("weapon")
	var ammo = player.get_meta("weapon", 0)
	_weapon.modulate = Color(1, 1, 1, 1.0 if ammo > 0 else 0.5)

	var key = player.get_meta("key", 0)
	for i in _keys.get_child_count():
		_keys.get_child(i).visible = key > i

		
func flip() -> void:
	_keys.get_children().map(func (x): x.flip_h = not x.flip_h)
	_weapon.flip_h = not _weapon.flip_h

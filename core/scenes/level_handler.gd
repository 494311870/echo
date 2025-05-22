extends Node

signal level_started
@export var levels: Array[Level]

var _current_level: int = -1

func _ready() -> void:
	next_level.call_deferred()


func next_level()-> void:
	_current_level += 1
	if _current_level >= levels.size():
		print("All levels completed!")
		_current_level = 0
#		return

	var level: Level = levels[_current_level]
	_enter_level(level)


func _enter_level(level: Level)-> void:
	owner.set_meta("level", level)
	level_started.emit()





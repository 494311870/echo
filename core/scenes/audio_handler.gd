extends Node

@export var  _music: AudioStreamPlayer
@export var  _sound: AudioStreamPlayer


func play_bgm() -> void:
	if _music.playing:
		return
	_music.play()

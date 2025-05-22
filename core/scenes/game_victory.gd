extends Control

func _ready() -> void:
	self.modulate = Color.TRANSPARENT
	

func show_victory() -> void:
	self.modulate = Color.TRANSPARENT
	self.visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)

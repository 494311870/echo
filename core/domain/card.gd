class_name Card
extends Resource

signal refresh_requested
@export var art: Texture2D
@export var flip_bottom: bool

var view: CardView
var is_resolved: bool = false

func can_pass(other_card: Card) -> bool:
	return true


func interact(other_card: Card)-> void:
	pass


func mark_resolved()-> void:
	is_resolved = true
	view.mark_resolved()


func refresh()-> void:
	refresh_requested.emit()




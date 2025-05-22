class_name Card
extends Resource

@export var art: Texture2D

var view: CardView


func can_pass(other_card: Card) -> bool:
	return true


func interact(other_card: Card)-> void:
	pass


func mark_resolved()-> void:
	view.mark_resolved()




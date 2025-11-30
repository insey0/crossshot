class_name Interactable
extends Area2D

@export var display_name: String
@export var globally_interactable: bool
@export var interact_limit: int
var interactable: bool = false

func _input(event: InputEvent) -> void:
	if globally_interactable and interactable and interact_limit != 0 and event.is_action_pressed("plr_interact"):
		interact_limit -= 1
		on_interact()

func on_interact():
	pass

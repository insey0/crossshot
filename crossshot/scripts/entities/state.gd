class_name State
extends Node

@export var subject: Node2D
@export var state_machine: StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_frame(delta: float) -> void:
	pass

func process_physics(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

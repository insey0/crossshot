# State Machine Base Class
class_name StateMachine
extends Node

@export var initial_state: State # Initial state node
@export var animation_player: AnimationPlayer # Subject's AnimationPlayer
@export var sprite: Sprite2D # Subject's sprite

var states: Dictionary = {}
var current_state: State

# Initialize state machine
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.subject = get_parent() as Node2D
	
	if initial_state:
		change_state(initial_state.name)

# Change state function
func change_state(state_name: String) -> void:
	if not states.has(state_name):
		push_error("StateMachine: Nonexistent state " + state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter()
	
	if animation_player:
		animation_player.play(state_name)

# Frame processor
func _process(delta: float) -> void:
	if current_state:
		current_state.process_frame(delta)

# Physics processor
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.process_physics(delta)

# Input handler
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

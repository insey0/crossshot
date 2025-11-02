extends CharacterBody2D

@export var direction: Vector2
@export var speed: float
@export var distance: float
var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	var target_position: Vector2 = start_position + direction.normalized() * distance
	var step = direction * speed * 50.0 * delta
	var distance_to_target = global_position.distance_to(target_position)
	
	if step.length() >= distance_to_target:
		start_position = global_position
		direction *= -1
	
	velocity = step
	move_and_slide()

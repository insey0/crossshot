extends Camera2D

@export var mode: String # "follow" / "scroll"

@export var target: Node2D
@export var follow_speed: float

@export var scroll_direction: Vector2
@export var scroll_speed: float

func _process(delta):
	if mode == "follow":
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
	elif mode == "scroll":
		global_position += scroll_direction * scroll_speed * delta

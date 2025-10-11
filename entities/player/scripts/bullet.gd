extends Area2D

var speed: float = 1000.0

func _physics_process(delta: float) -> void:
	global_position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacles"):
		queue_free()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("camera_zone"):
		queue_free()

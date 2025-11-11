extends Sprite2D

var sin_val: float = 0.0

func _process(delta: float) -> void:
	sin_val += randf_range(0.01, 0.1)
	position.y += sin(sin_val)/5

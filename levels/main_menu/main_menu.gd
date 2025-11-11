extends Node2D

var min_gib_scale: float = 20.0
var max_gib_scale: float = 50.0
var min_gib_pos: Vector2 = Vector2(50.0, 50.0)
var max_gib_pos: Vector2 = Vector2(1870.0, 1030.0)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().reload_current_scene()

func _ready() -> void:
	for child: Node2D in get_children():
		var fixed_scale = randf_range(min_gib_scale, max_gib_scale)
		child.position = Vector2(randf_range(min_gib_pos.x, max_gib_pos.x), randf_range(min_gib_pos.y, max_gib_pos.y))
		child.scale = Vector2(fixed_scale, fixed_scale)
		child.rotation = randf_range(-180.0, 180.0)

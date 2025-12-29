extends AnimationPlayer

@export var timer: Timer

func  _ready() -> void:
	timer.wait_time = randf_range(0.5, 2.0)

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.5, 2.0)
	speed_scale = randf_range(0.5, 2.0)
	timer.start()

func _on_animation_finished(anim_name: StringName) -> void:
	var rnd = randi_range(0,10)
	if anim_name == "unwrap":
		if rnd > 8:
			play("wrapup")
		if rnd <= 8:
			play("wiggle")
	if anim_name == "wrapup":
		play("unwrap")
	if anim_name == "wiggle":
		if rnd > 8:
			play("wrapup")
		if rnd <= 8:
			play("wiggle")

class_name Powerup
extends RigidBody2D

@export var has_physics: bool
@export var is_destructible: bool
@export var destruction_time: int
@export var effect: Texture2D

@export var display_name: String
@export var description: String

func _ready() -> void:
	if is_destructible:
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = destruction_time
		timer.start()
		timer.timeout.connect(_on_timer_timeout)

@warning_ignore("unused_parameter")
func on_pickup(player: CharacterBody2D):
	pass

func _on_timer_timeout():
	queue_free()

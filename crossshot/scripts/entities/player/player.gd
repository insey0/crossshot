extends CharacterBody2D

@export var input: InputManager
@export var movement: MovementManager
@export var sound: SoundManager

@export var anim: AnimationPlayer

func _ready() -> void:
	input.connect("act_jump", _on_jump)

func _physics_process(delta: float) -> void:
	movement.apply_gravity(self, delta)
	movement.handle_movement(self, input.horizontal_direction, delta)

	movement.renew_jumps(self)
	
	if input.mouse_pos.x > global_position.x:
		anim.play(&"player_unflipped")
	else:
		anim.play(&"player_flipped")

func _on_jump() -> void:
	movement.jump(self)

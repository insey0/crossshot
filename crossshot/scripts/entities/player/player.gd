class_name Player
extends Entity

@export var flip: AnimationPlayer
@export var weapon: Node2D

func _ready() -> void:
	# Collision layers setup
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	
	# Detect box collision layers setup
	detect_box.set_collision_layer_value(1, false)
	detect_box.set_collision_layer_value(5, true)
	
	detect_box.set_collision_mask_value(1, false)
	detect_box.set_collision_mask_value(3, true)
	detect_box.set_collision_mask_value(4, true)
	detect_box.set_collision_mask_value(5, true)
	detect_box.set_collision_mask_value(6, true)
	detect_box.set_collision_mask_value(8, true)
	
	# Signal connections
	controller.connect("act_jump", _on_act_jump)
	detect_box.connect("body_entered", _on_detect_box_body_entered)
	movement.connect("jumped", _on_jump_made)

func _physics_process(delta: float) -> void:
	# Move & fall
	movement.apply_gravity(self, delta)
	movement.handle_movement(self, controller.horizontal_direction, delta)
	
	# Renew jumps
	movement.renew_jumps(self)
	
	# Player flip code
	if controller.mouse_pos.x > global_position.x:
		flip.play(&"player_unflipped")
	else:
		flip.play(&"player_flipped")

# Jump
func _on_act_jump() -> void:
	movement.jump(self)

# Play jump sound
func _on_jump_made() -> void:
	sound.play_sound("player_jump_" + str(randi_range(1,2)))

# Detect box code
func _on_detect_box_body_entered(_body: Node2D) -> void:
	pass

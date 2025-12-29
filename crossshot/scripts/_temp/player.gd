class_name Player
extends CharacterBody2D

@export var input: InputManager
@export var movement: MovementComponent
@export var weapon: WeaponComponent
@export var health: HealthManager
@export var sound: SoundManager

@export var message: MessageManager

signal picked_up_powerup(effect_texture: Texture2D, effect_name: String, effect_description: String)

var total_damage: int = 0

func _physics_process(delta: float) -> void:
	# Movement
	weapon.handle_aim(global_position, input.mouse_pos)
	movement.handle_gravity(self, delta)
	movement.handle_movement(self, input.horizontal_direction, delta)
	movement.renew_jumps(self)
	
	# Shooting (auto)
	if input.shoot_held and weapon.automatic:
		weapon.shoot()
		
	# Animation
	if weapon.current_weapon != "":
		pass

# Jump (signal)
func _on_jump() -> void:
	if movement.handle_jump(self):
		sound.play_sound("player_jump_" + str(randi_range(1,2)))
	movement.handle_jump(self)
# Shoot (signal)
func _on_shoot() -> void:
	if not weapon.automatic:
		weapon.shoot()

# Health Change
func _on_health_changed(new_health: int, _new_max_health: int, damage_value: int, is_damaged: bool) -> void:
	if new_health > 0 and is_damaged:
		total_damage -= damage_value
		message.display("damage", [total_damage], 1.5)
	if not is_damaged:
		total_damage += damage_value
		message.display("heal", [total_damage], 1.5)
	if new_health == 0:
		message.display("death", [], 3.0)

# Collision checking (enemies, dangers, interactables...)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("dangers"):
		var danger: DangerProperties = area
		movement.handle_bounce(self, (global_position - danger.global_position).normalized(), danger.bounce_power)
		health.take_damage(danger.damage)
	if area.is_in_group("interactables"):
		var interactable: Interactable = area
		interactable.interactable = true
		message.display("e_to_interact", [interactable.display_name], 0.0)

# Exit collision checking (enemies, dangers, interactables...)
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("interactables"):
		var interactable: Interactable = area
		interactable.interactable = false
		message.hide()

# Physics collision checking
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("powerups"):
		var pwup: Powerup = body
		message.display("picked_up", [pwup.display_name], 1.0)
		picked_up_powerup.emit(pwup.effect, pwup.display_name, pwup.description)
		pwup.on_pickup(self)
		pwup.queue_free()
		sound.play_sound("player_pickup_powerup")

# Message values cleaning
func _on_message_hidden() -> void:
	total_damage = 0

class_name Player
extends CharacterBody2D

@export var weapon_node: Node2D
@export var weapon_sprite: AnimatedSprite2D
@export var sprite: AnimatedSprite2D

@export var input: InputComponent
@export var movement: MovementComponent
@export var weapon: WeaponComponent
@export var health: HealthComponent

@export var message: MessageManager

signal picked_up_powerup(effect_texture: Texture2D, effect_name: String, effect_description: String)

var total_damage: int = 0

func _physics_process(delta: float) -> void:
	# Movement
	movement.handle_gravity(self, delta)
	movement.handle_movement(self, input.direction, delta)
	
	# Aim
	weapon_node.rotation = weapon.handle_aim(global_position, input.mouse_pos)
	
	# Animation
	if input.mouse_pos.x > position.x:
		sprite.flip_h = false
		weapon_sprite.flip_v = false
	else:
		sprite.flip_h = true
		weapon_sprite.flip_v = true
	
	# Double Jump
	if is_on_floor():
		movement.jump_count = 2

# Прыжок (signal)
func _on_jump() -> void:
	movement.handle_jump(self)
# Выстрел (signal)
func _on_shoot() -> void:
	if not weapon.automatic and weapon.can_single_shoot:
		weapon.shoot()
		weapon.can_single_shoot = false
func _on_shoot_delay_timeout() -> void:
	if weapon.automatic and input.shoot_held:
		weapon.shoot()
	if not weapon.automatic:
		weapon.can_single_shoot = true

# Изменение здоровья
func _on_health_changed(new_health: int, _new_max_health: int, damage_value: int, is_damaged: bool) -> void:
	if new_health > 0 and is_damaged:
		total_damage -= damage_value
		message.display("damage", [total_damage], 1.5)
	if not is_damaged:
		total_damage += damage_value
		message.display("heal", [total_damage], 1.5)
	if new_health == 0:
		message.display("death", [], 3.0)

# Проверка столкновений (враги, опасности, интерактивные объедки...)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("dangers"):
		var danger: DangerProperties = area
		movement.handle_bounce(self, (global_position - danger.global_position).normalized(), danger.bounce_power)
		health.take_damage(danger.damage)
	if area.is_in_group("interactables"):
		var interactable: Interactable = area
		interactable.interactable = true
		message.display("e_to_interact", [interactable.display_name], 0.0)

# Проверка выхода из столкновения (враги, опасности, интерактивные объедки...)
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("interactables"):
		var interactable: Interactable = area
		interactable.interactable = false
		message.hide()

# Проверка столкновений с физическими объедками
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("powerups"):
		var pwup: Powerup = body
		message.display("picked_up", [pwup.display_name], 1.0)
		picked_up_powerup.emit(pwup.effect, pwup.display_name, pwup.description)
		pwup.on_pickup(self)
		pwup.queue_free()

func _on_message_hidden() -> void:
	total_damage = 0

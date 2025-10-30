extends CharacterBody2D

@export var weapon_node: Node2D
@export var weapon_sprite: AnimatedSprite2D
@export var sprite: AnimatedSprite2D

@export var bullet: PackedScene
@export var muzzle: Marker2D
@export var shoot_delay: Timer

@export var input: InputComponent
@export var movement: MovementComponent
@export var weapon: WeaponComponent
@export var health: HealthComponent

@export var inventory: ItemEquipmentComponent

@export var message: RichTextLabel

var pickup_item: String = ""

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

# Jump (signal)
func _on_jump() -> void:
	movement.handle_jump(self)

# Shoot (signal)
func _on_shoot() -> void:
	weapon.shoot(bullet, muzzle, shoot_delay)

func _on_shoot_delay_timeout() -> void:
	if weapon.automatic and input.shoot_held:
		weapon.shoot(bullet, muzzle, shoot_delay)

func _on_item_entered(area: Area2D) -> void:
	if area.is_in_group("items_world"):
		var item: ItemWorld = area.get_parent()
		pickup_item = item.item_name
		message.text = "[color=white]'E' - pick up [/color][color=yellow]" + pickup_item

func _on_item_exited(area: Area2D) -> void:
	if area.is_in_group("items_world"):
		pickup_item = ""
		message.text = ""

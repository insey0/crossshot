class_name Interactive
extends Area2D

@export var display_name: String
@export var interactable: bool = true
@export var interact_limit: int = -1
var reachable: bool = false
var target: Entity = null

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(8, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(5, true)
	
	add_to_group("interactives")
	
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

# Check if entity interacts
func on_entity_interact() -> void:
	if interactable and reachable and interact_limit != 0:
		interact_limit -= 1
		interact()

# Check for entities in reach
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Entity and not target:
		target = area.get_parent()
		target.controller.connect("interact", on_entity_interact)
		reachable = true

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() == target:
		target.controller.disconnect("interact", on_entity_interact)
		target = null
		reachable = false

func interact() -> void:
	pass

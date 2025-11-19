# Animation Manager
class_name AnimationManager
extends Node

@export var animation_player: AnimationPlayer

#func play_animation(id: String, speed: float, start_frame: int):
	#pass

# Flip sprites towards the target
func flip_sprites_targeted(node: Node2D, target_position: Vector2):
	var sprites: Array = _find_sprites(node)
	var flip: bool = target_position.x < node.global_position.x
	
	for sprite: Node2D in sprites:
		if sprite.is_in_group("flip_h"):
			sprite.flip_h = flip
		if sprite.is_in_group("flip_v"):
			sprite.flip_v = flip

# Create sprites array for a node
func _find_sprites(node: Node) -> Array:
	var sprites: Array = []
	for child in node.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			sprites.append(child)
		sprites.append_array(_find_sprites(child))
	
	return sprites

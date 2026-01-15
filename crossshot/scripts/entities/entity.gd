class_name Entity
extends CharacterBody2D

# Class-independent managers
@export var controller: Node # A component that is responsible for AI/Input
# Todo: Controller class
@export var movement: Node # A component that contains movement patterns
# Todo: BaseMovement class

# Base managers
@export var health: HealthManager # Basic health component
@export var sound: SoundManager # Sound component that contains sound cache
@export var effects: EffectManager # Basic effect manager

# Nodes
@export var anim: AnimationPlayer # Animator
@export var detect_box: Area2D # Hitbox for detecting other entities/dangers/pickups

func _ready() -> void:
	add_to_group("entities")

class_name PassiveEffect
extends Control

@onready var texture_rect: TextureRect = $effect_texture

@export var amount_label: Label

var effect_id: String
var clickable: bool = false

func _input(event: InputEvent) -> void:
	if clickable and event is InputEventMouseButton:
		if event.is_action_pressed("plr_effect_remove"):
			Global.emit_signal("call_player_effect_remove", effect_id, false)

func _on_mouse_entered() -> void:
	clickable = true

func _on_mouse_exited() -> void:
	clickable = false

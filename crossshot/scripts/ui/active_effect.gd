class_name ActiveEffect
extends Control

@onready var texture_rect: TextureRect = $effect_texture
@onready var outline: TextureRect = $outline

@export var amount_label: Label
@export var time_left_label: Label

var effect_id: String
var clickable: bool = false

func _input(event: InputEvent) -> void:
	if clickable and event is InputEventMouseButton:
		if event.is_action_pressed("plr_effect_remove"):
			Global.emit_signal("call_player_effect_remove", effect_id, true)
		if event.is_action_pressed("plr_effect_activate"):
			Global.emit_signal("call_player_effect_activate", effect_id, true)

func _on_mouse_entered() -> void:
	clickable = true
	outline.visible = true

func _on_mouse_exited() -> void:
	clickable = false
	outline.visible = false

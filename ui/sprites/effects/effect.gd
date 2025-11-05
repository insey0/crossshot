class_name Effect
extends Control

var effect_texture: Texture2D
var tooltip: RichTextLabel
var display_name: String
var description: String
var stack: int

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_draw()
	size_flags_horizontal = Control.SIZE_FILL
	size_flags_vertical = Control.SIZE_FILL

func _on_mouse_entered():
	tooltip.text = "[font_size=22][color=#FFFFFF]" + str(display_name) + "[p][color=#С4С4С4][font_size=18]" + str(description)

func _on_mouse_exited():
	tooltip.text = ""

func _draw():
	if effect_texture:
		draw_texture_rect(effect_texture, Rect2(Vector2.ZERO, size), false)

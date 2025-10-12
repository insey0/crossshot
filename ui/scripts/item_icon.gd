class_name ItemIcon
extends Area2D

@export var amount_label: Label
@export var texture: TextureRect
var current_set: int
var current_slot: int

var mouse_overlaps: bool
var is_dragged: bool
var drag_offset: Vector2

signal drag_started(item_name)
signal drag_ended(set_number, slot_number)

# Функции перетаскивания
func start_dragging():
	is_dragged = true
	drag_offset = global_position - get_global_mouse_position()
	z_index = 100
	modulate.a = 0.8
	drag_started.emit()
func end_dragging():
	is_dragged = false
	z_index = 0
	modulate.a = 1.0
	drag_ended.emit()

# Проверка наложения мыши
func _on_mouse_entered() -> void:
	mouse_overlaps = true
	modulate = Color(1.2, 1.2, 1.2)
func _on_mouse_exited() -> void:
	mouse_overlaps = false
	modulate = Color(1.2, 1.2, 1.2)

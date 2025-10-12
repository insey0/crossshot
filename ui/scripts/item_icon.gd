# НЕ РАБОТАЕТ
class_name ItemIcon
extends TextureRect

@export var amount_label: Label
var item_name: String
var current_set: int
var current_slot: int

var mouse_overlaps: bool = false
var is_dragged: bool = false

signal drag_started(item: ItemIcon)

func _process(_delta: float) -> void:
	if is_dragged:
		global_position = get_global_mouse_position()

func start_dragging():
	is_dragged = true
	z_index = 100
	modulate.a = 0.8
	drag_started.emit(self)
func end_dragging():
	is_dragged = false
	z_index = 0
	modulate.a = 1.0

# Проверка наложения мыши
func _on_mouse_entered() -> void:
	mouse_overlaps = true
	if not is_dragged:
		modulate = Color(1.2, 1.2, 1.2)
func _on_mouse_exited() -> void:
	mouse_overlaps = false
	modulate = Color(1.0, 1.0, 1.0)

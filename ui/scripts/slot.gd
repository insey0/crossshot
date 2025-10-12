class_name Slot
extends TextureRect

@export var area: Area2D

@export var set_number: int
@export var slot_number: int

signal mouse_entered_slot(get_set: int, get_slot: int)

func setup_slot(new_set_number: int, new_slot_number: int):
	slot_number = new_slot_number
	set_number = new_set_number

func _on_mouse_entered() -> void:
	mouse_entered_slot.emit(set_number, slot_number)

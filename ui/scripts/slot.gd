class_name Slot
extends TextureRect

@export var set_number: int
@export var slot_number: int

func setup_slot(new_set_number: int, new_slot_number: int):
	slot_number = new_slot_number
	set_number = new_set_number

class_name ItemIcon
extends TextureRect

var item_name: String

var current_set: int
var current_slot: int

var is_dragged: bool = false

func move(new_set: int, new_slot: int):
	for slot: Slot in owner.inventory_container:
		if slot.set_id == new_set and slot.slot_id == new_slot:
			is_dragged = false
			reparent(slot)

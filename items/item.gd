class_name Item
extends Node

@export_group("Item Identify")
@export var item_name: String
@export var item_sprite: Texture2D

@export_group("Item Properties")
@export var consumable: bool
@export var max_amount: int = 100

@export_group("Item UI")
@export var display_name: String
@export var description: String
@export var slot_icon: Texture2D

func on_equip(): # If passive (accessories)
	if consumable:
		return
	pass

func on_unequip():
	if consumable:
		return
	pass

func on_use(): # If consumable
	if not consumable:
		return
	pass

func on_drop():
	pass

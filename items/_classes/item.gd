class_name Item
extends Node

@export var item_name: String
@export var slot_icon: Texture2D

@export var consumable: bool
@export var max_amount: int = 100

@export var display_name: String
@export var description: String

@export var item_world: PackedScene
@export var item_projectile: PackedScene

func on_equip(): # Эффект при экипировке
	pass

func on_unequip():
	pass

func on_use(): # Эффект при использовании (расходуемые)
	pass

func on_drop(): # Функция выбрасывания из инвентаря
	pass

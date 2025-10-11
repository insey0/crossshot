# Item manager component
class_name ItemComponent
extends Node

var sets: int = 2: # Amount of sets
	set(value):
		update_sets(value)
var current_set: int = 0 # The ID of a current set

var slots_per_set: int = 2 # Amount of slots per one set
var current_slot: int: # Current selected slot (if the item has on_use() function)
	set(value):
		current_slot = clampi(value, 0, slots_per_set - 1)

var items: Array = [] # The name of each item per slot in each set
var _item_cache: Dictionary = {}

func _ready() -> void:
	update_sets(sets)

func update_sets(new_sets_amount):
	if len(items) < new_sets_amount:
		for set_iter in range(new_sets_amount - len(items)):
			var new_set: Array
			for slot_iter in range(slots_per_set):
				new_set.append({"name": "", "amount": 0})
			items.append(new_set)
	else:
		for set_iter in range(len(items) - new_sets_amount):
			items.pop_back()

func pickup_item(item_name: String, item_amount: int, set_to_equip_in: int) -> bool:
	for slot_iter in range(len(items[set_to_equip_in])):
		if items[set_to_equip_in][slot_iter]["name"] == "":
			items[set_to_equip_in][slot_iter] = {"name": item_name, "amount": item_amount}
			equip_item(item_name)
			return true # Successfully equipped an item
	return false # Free slots not found

func use_item() -> void:
	var item_name = items[current_set][current_slot]["name"]
	if item_name == "":
		return
	
	var item: Item = _get_cached_item(item_name)
	if item and item.consumable:
		item.on_use()
	else:
		return

func equip_item(item_name: String):
	if item_name == "":
		return
	
	var item: Item = _get_cached_item(item_name)
	if item and not item.consumable:
		item.on_equip()
	else:
		return

func unequip_item():
	var item_name = items[current_set][current_slot]["name"]
	if item_name == "":
		return
	var item: Item = _get_cached_item(item_name)
	if item:
		if item.consumable:
			item.on_unequip()
		item.queue_free()
	else:
		return

func _get_cached_item(item_name: String):
	if _item_cache.has(item_name):
		return _item_cache[item_name]
	
	var item_path = "res://items/%s.tscn" % item_name
	if ResourceLoader.exists(item_path):
		var item_scene = load(item_path)
		var item_instance: Item = item_scene.instantiate()
		
		add_child(item_instance)
		_item_cache[item_name] = item_instance
		return item_instance # Item scene instantiated
	return null # Item not found

# ItemComponent
class_name ItemEquipmentComponent
extends Node

static var instance: ItemEquipmentComponent

# Сигналы для UI
signal items_updated(signal_items_array: Array) # items: Array изменён

var sets: int = 2: # Количество сетов
	set(value):
		update_sets(value)
		items_updated.emit(items)
var current_set: int = 0 # ID текущего выбранного сета

var slots_per_set: int = 2: # Количество слотов на каждый сет
	set(value):
		update_slots(value)
		items_updated.emit(items)
var current_slot: int: # Текущий выбранный слот
	set(value):
		current_slot = clampi(value, 0, slots_per_set - 1)

var items: Array = [] # Массив предметов в формате:
# items: Array = [
# [ # Сет 1
# {"name": "magnetic_gloves", "amount": 1}
# {"name": "rocket_boots", "amount": 1}
# {"name": "grenade", "amount": 8}
# ],
# [ # Сет 2
# {"name": "medkit", "amount": 4}
# {"name": "gravity_spring", "amount": 2}
# {"name": "", "amount": 0}
# ]
# И так далее...
# ]

var item_cache: Dictionary = {} # Кэш ссылок на сцены класса Item
@export var placeholder_icon: Texture2D

func _ready() -> void:
	instance = self
	update_sets(sets) # Задать стартовое кол-во сетов
	update_slots(slots_per_set)

func update_sets(new_sets_amount): # Обновление количества сетов
	# Расширение
	if len(items) < new_sets_amount:
		for set_iter in range(new_sets_amount - len(items)):
			var new_set: Array
			for slot_iter in range(slots_per_set):
				new_set.append({"name": "", "amount": 0})
			items.append(new_set)
	# Сужение
	else:
		for set_iter in range(len(items) - new_sets_amount):
			items.pop_back()
	# Сигнал для UI
	items_updated.emit(items)

func update_slots(new_slots_amount):
	var first_empty: int = 0
	for set_iter in range(sets):
		for new_slots in range(new_slots_amount - len(items[set_iter])):
			items[set_iter].insert(0, {"name": "", "amount": 0})
		for slot_iter in range(new_slots_amount):
			if items[set_iter][slot_iter]["name"] != "":
				items[set_iter][first_empty] = items[set_iter][slot_iter]
				items[set_iter][slot_iter] = {"name": "", "amount": 0}
				first_empty += 1
	items_updated.emit(items)

func pickup_item(item_name: String, item_amount: int, set_to_equip_in: int) -> bool:
	for slot_iter in range(len(items[set_to_equip_in])): # Итерация по слотам
		if items[set_to_equip_in][slot_iter]["name"] == "": # Найден пустой слот
			items[set_to_equip_in][slot_iter] = {"name": item_name, "amount": item_amount}
			equip_item(item_name)
			# Сигнал для UI
			items_updated.emit(items)
			return true # Предмет успешно экипирован
	return false # Нет свободных слотов

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
		if item.data.consumable:
			item.on_unequip()
		item.queue_free()
	else:
		return

func get_item_texture(item_name: String):
	if item_cache.has(item_name):
		return item_cache[item_name].slot_icon
	return placeholder_icon

func _get_cached_item(item_name: String):
	if item_cache.has(item_name):
		return item_cache[item_name]
	
	var item_path = "res://items/{0}/{0}.tscn".format([item_name])
	if ResourceLoader.exists(item_path):
		var item_scene = load(item_path)
		var item_instance: Item = item_scene.instantiate()
		
		add_child(item_instance)
		item_cache[item_name] = item_instance
		return item_instance # Item scene instantiated
	return null # Item not found

# НЕ РАБОТАЕТ
func _on_ui_item_moved(item_icon_name: String, item_icon_amount: int,
from_set: int, to_set: int, from_slot: int, to_slot: int) -> void:
	items[from_set][from_slot] = {"name": "", "amount": 0}
	items[to_set][to_slot] = {"name": item_icon_name, "amount": item_icon_amount}
	items_updated.emit(items)

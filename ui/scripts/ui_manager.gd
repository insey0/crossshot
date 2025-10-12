class_name UIManager
extends Control

@export var slot: PackedScene
@export var item_icon: PackedScene
@export var equipment_ui: Control

const SIZE: float = 128.0
const OFFSET_X: float = SIZE + 16.0
const OFFSET_Y: float = SIZE + 24.0
const START_POS: Vector2 = Vector2(1728.0, 896.0)
const ITEM_ICON_OFFSET: float = 16.0

# signal item_moved(from_set: int, to_set: int, from_slot: int, to_slot: int)

func _on_items_updated(signal_items_array: Array) -> void:
	update_slots(signal_items_array)

func update_slots(items: Array):
	# Очистка предыдущего интерфейса (и слоты и предметы)
	for child in equipment_ui.get_children():
		child.queue_free()
	# Обновление количества сетов и слотов
	# Обновление предметов в слотах
	for sets in range(len(items)):
		var new_pos: Vector2
		new_pos.y = START_POS.y - OFFSET_Y * sets
		for slots in range(len(items[sets])):
			new_pos.x = START_POS.x - OFFSET_X * slots
			# Создание слота
			var slot_instance: Slot = slot.instantiate()
			equipment_ui.add_child(slot_instance)
			slot_instance.position = new_pos
			slot_instance.setup_slot(sets, slots)
			# Проверка предмета в слоте
			var item_name = items[sets][slots]["name"]
			var item_amount = items[sets][slots]["amount"]
			if item_name != "" and item_amount != 0:
				# Создание предмета в текущем слоте
				var item_icon_instance: ItemIcon = item_icon.instantiate()
				equipment_ui.add_child(item_icon_instance)
				# Настройка предмета:
				item_icon_instance.position = new_pos + Vector2(ITEM_ICON_OFFSET, ITEM_ICON_OFFSET)
				var new_texture = ItemEquipmentComponent.instance.get_item_texture(item_name)
				
				item_icon_instance.texture.texture = new_texture
				item_icon_instance.amount_label.text = str(item_amount)
				
				item_icon_instance.current_set = sets
				item_icon_instance.current_slot = slots

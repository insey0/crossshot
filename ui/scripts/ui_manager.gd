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

var slots_arr: Array = []
var current_dragged_item: ItemIcon = null

signal item_moved(item_icon_name: String, item_icon_amount: int, from_set: int, to_set: int, from_slot: int, to_slot: int)

func _process(_delta: float) -> void:
	if current_dragged_item and current_dragged_item.is_dragged:
		check_slot_under_mouse()
# НЕ РАБОТАЕТ
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and current_dragged_item:
			var target_slot: Slot = check_slot_under_mouse()
			current_dragged_item.end_dragging()
			if target_slot:
				item_moved.emit(current_dragged_item.item_name, 
				int(current_dragged_item.amount_label.text),
				current_dragged_item.current_set, 
				target_slot.set_number, 
				current_dragged_item.current_slot, 
				target_slot.slot_number)
			else:
				pass # Логика выбрасывания
			current_dragged_item = null

func check_slot_under_mouse() -> Slot:
	var mouse_pos = get_global_mouse_position()
	for slot_iter in slots_arr:
		if slot_iter.get_global_rect().has_point(mouse_pos):
			return slot_iter
	return null

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
				# Подключение сигналов перетаскивания
				item_icon_instance.drag_started.connect(_on_item_drag_start)
				# Настройка предмета:
				item_icon_instance.global_position = new_pos + Vector2(ITEM_ICON_OFFSET, ITEM_ICON_OFFSET)
				var new_texture = ItemEquipmentComponent.instance.get_item_texture(item_name)
				
				item_icon_instance.item_name = item_name
				item_icon_instance.texture = new_texture
				item_icon_instance.amount_label.text = str(item_amount)
				
				item_icon_instance.current_set = sets
				item_icon_instance.current_slot = slots
	slots_arr = get_tree().get_nodes_in_group("inventory_slots") # Масств слотов

func _on_item_drag_start(dragged_item_icon: ItemIcon):
	current_dragged_item = dragged_item_icon

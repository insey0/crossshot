class_name UIManager
extends Control

signal slot_selected(set_index, slot_index)
signal item_moved(from_set, from_slot, to_set, to_slot)
signal item_used(set_index, slot_index)
signal item_dropped(set_index, slot_index)

# Ссылки на ноды
var slots_container: GridContainer
var item_component: Node
var slots: Array = []

# Настройки инвентаря
var sets_count: int = 2
var slots_per_set: int = 4
var current_set: int = 0
var current_slot: int = 0

# Для перемещения предметов
var drag_start_slot: Slot = null
var is_dragging: bool = false

# Выбор слотов с помощью колёсика
# Перемещение предметов между слотами с помощью мыши
# Взаимодействие с ItemComponent
#	Определение выбранного предмета
#	Перемещение предметов по массиву items в зависимости от номеров ряда и колонки выбранного слота
#	Вызов функции on_equip при подбирании/повторной экипировке
#	Вызов функции on_unequip при снятии/выбрасывании
#	Удаление при выбрасывании
#	Вызов функции on_use и уменьшение количества при использовании (для одноразовых)

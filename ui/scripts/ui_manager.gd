class_name UIManager
extends Control

# Информация об игре
@export var game_info: Label
var app_version: String
var fps_update_timer: float = 0.0

signal slot_selected(set_index, slot_index)
signal item_moved(from_set, from_slot, to_set, to_slot)
signal item_used(set_index, slot_index)
signal item_dropped(set_index, slot_index)

# Настройки инвентаря
@export var inventory_container: GridContainer
var sets_count: int = 2
var slots_per_set: int = 4

var current_set: int = 0
var current_slot: int = 0

# Для перемещения предметов
var drag_start_slot: Slot = null
var is_dragging: bool = false

func _ready():
	app_version = ProjectSettings.get_setting("application/config/version")

func _process(delta: float) -> void:
	fps_update_timer += delta
	if fps_update_timer >= 0.2:
		fps_update_timer = 0.0
		game_info.text = "CroSSShot!\n%s\nFPS: %d" % [app_version, Engine.get_frames_per_second()]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("eqp_inventory"): # Переключение видимости инвентаря
		inventory_container.visible = !inventory_container.visible

# Выбор слотов с помощью колёсика
# Перемещение предметов между слотами с помощью мыши
# Взаимодействие с ItemComponent
#	Определение выбранного предмета
#	Перемещение предметов по массиву items в зависимости от номеров ряда и колонки выбранного слота
#	Вызов функции on_equip при подбирании/повторной экипировке
#	Вызов функции on_unequip при снятии/выбрасывании
#	Удаление при выбрасывании
#	Вызов функции on_use и уменьшение количества при использовании (для одноразовых)

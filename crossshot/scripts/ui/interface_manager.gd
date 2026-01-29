class_name InterfaceManager
extends Node

@export var hp_bar: TextureProgressBar
@export var hp_percentage: Label

@export var active_effect: PackedScene
@export var passive_effect: PackedScene

@export var actives_container: GridContainer
@export var passives_container: GridContainer

func _ready() -> void:
	Global.connect("call_ui_player_health_updated", update_health)
	Global.connect("call_ui_new_effect", new_effect)
	Global.connect("call_ui_effect_amount_updated", update_effect_amount)
	Global.connect("call_ui_effect_time_update", update_active_effect_time)
	Global.connect("call_ui_effect_removed", remove_effect)

# Update health
func update_health(new_health: int, new_max_health: int) -> void:
	# Update percentage
	hp_percentage.text = str(new_health) + "%"
	# Update bar
	hp_bar.value = new_health
	hp_bar.max_value = new_max_health

func new_effect(is_active: bool, effect_id: String, texture: Texture2D) -> void:
	if is_active:
		var active_effect_instance = active_effect.instantiate() as ActiveEffect
		actives_container.add_child(active_effect_instance)
		active_effect_instance.effect_id = effect_id
		active_effect_instance.texture_rect.texture = texture
	else:
		var passive_effect_instance = passive_effect.instantiate() as PassiveEffect
		passives_container.add_child(passive_effect_instance)
		passive_effect_instance.effect_id = effect_id
		passive_effect_instance.texture_rect.texture = texture

func update_effect_amount(effect_id: String, new_amount: int, is_active: bool) -> void:
	if is_active:
		for child in actives_container.get_children():
			if child is ActiveEffect and child.effect_id == effect_id:
				child.amount_label.text = str(new_amount) + 'x'
	else:
		for child in passives_container.get_children():
			if child is PassiveEffect and child.effect_id == effect_id:
				child.amount_label.text = str(new_amount) + 'x'

func update_active_effect_time(effect_id: String, timestring: String) -> void:
	for child in actives_container.get_children():
		if child is ActiveEffect and child.effect_id == effect_id:
			child.time_left_label.text = timestring
			if not child.time_left_label.visible and not child.time_left_label.text == '0s':
				child.time_left_label.visible = true
			elif child.time_left_label.text == '0s':
				child.time_left_label.visible = false

func remove_effect(effect_id: String, is_active: bool) -> void:
	if is_active:
		for child in actives_container.get_children():
			if child is ActiveEffect and child.effect_id == effect_id:
				child.queue_free()
	else:
		for child in passives_container.get_children():
			if child is PassiveEffect and child.effect_id == effect_id:
				child.queue_free()

func update_weapon(new_weapon_id: String, weapon_icon: TextureRect) -> void:
	pass

func update_ammo(new_ammo: int, ammo_label: Label) -> void:
	pass

func update_tabmenu_visibility(tabmenu: Container) -> void:
	if not tabmenu.visible:
		tabmenu.visible = true
	else:
		tabmenu.visible = false

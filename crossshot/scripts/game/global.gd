extends Node

var is_devmode_on: bool = false

# Signals
# User Interface Calls
signal call_ui_player_health_updated(new_health: int, new_max_health: int)

signal call_ui_new_effect(is_active: bool, effect_id: String, texture: Texture2D)
signal call_ui_effect_amount_updated(effect_id: String, new_amount: int, is_active: bool)
signal call_ui_effect_removed(effect_id: String, is_active: bool)
signal call_ui_effect_time_update(effect_id: String, timestring: String)

# Effect Manager Calls
signal call_player_effect_activate(effect_id: String, is_active: bool)
signal call_player_effect_remove(effect_id: String)

# Data & Cache
var audio_path: String = "user://audio/" #"audio/"
var audio_cache: Dictionary = {}

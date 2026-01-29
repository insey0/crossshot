# Entity Effect Manager
class_name EffectManager
extends Node

var target: Player

var active_effects: Dictionary
var passive_effects: Dictionary

func _ready() -> void:
	if get_parent() is Entity:
		target = get_parent()
	
	Global.connect("call_player_effect_activate", activate)
	Global.connect("call_player_effect_remove", deactivate)

func add(effect_id: String, is_active: bool,
active_time: float, is_stackable: bool, max_stack: int, texture: Texture2D):
	# Adding a passive effects
	if not is_active:
		# Creating a new effect
		if not passive_effects.has(effect_id):
			passive_effects[effect_id] = {
				"amount": 1,
				"activated": true,
				}
			Global.emit_signal("call_ui_new_effect", is_active, effect_id, texture)
		# Adding to a stack
		elif is_stackable and passive_effects[effect_id]["amount"] < max_stack:
			passive_effects[effect_id]["amount"] += 1
			Global.emit_signal("call_ui_effect_amount_updated", effect_id, passive_effects[effect_id]["amount"], is_active)
		activate(effect_id, false)
	# Adding an active effect
	else:
		# Creating a new effect
		if not active_effects.has(effect_id):
			active_effects[effect_id] = {
				"amount": 1,
				"activated": false,
				"active_time": active_time,
				"time_left": active_time
				}
			Global.emit_signal("call_ui_new_effect", is_active, effect_id, texture)
		# Adding to a stack
		elif is_stackable and active_effects[effect_id]["amount"] < max_stack:
			active_effects[effect_id]["amount"] += 1
			Global.emit_signal("call_ui_effect_amount_updated", effect_id, active_effects[effect_id]["amount"], is_active)

func activate(effect_id: String, is_active: bool):
	if (is_active and not effect_id in active_effects.keys()) or \
	(not is_active and not effect_id in passive_effects.keys()):
		return
	
	if is_active and active_effects[effect_id]["activated"]:
		return

	# Actual effect behaviour
	match effect_id:
		"shoot_delay":
			if target.weapon.weapon.shoot_delay > 0.05:
				target.weapon.weapon.shoot_delay -= 0.05
		"double_jump":
			target.movement.max_extra_jumps = 1
	
	# Shared behaviour for active effects
	if is_active:
		active_effects[effect_id]["activated"] = true
		
		var active_timer := Timer.new()
		add_child(active_timer)
		active_timer.one_shot = false
		active_timer.wait_time = 1.0
		
		active_timer.connect("timeout", _on_active_tick.bind(active_timer, effect_id))
		
		active_timer.start()
		target.sound.play_sound("effect_activate")
		Global.emit_signal("call_ui_effect_time_update", effect_id, str(int(active_effects[effect_id]["active_time"])) + 's')
	else:
		passive_effects[effect_id]["activated"] = true

func deactivate(effect_id: String, is_active: bool):
	# Actual effect deactivation behaviour
	match effect_id:
		"shoot_delay":
			target.weapon.weapon.shoot_delay += 0.05
		"double_jump":
			target.movement.max_extra_jumps = 0

	if active_effects.has(effect_id) or passive_effects.has(effect_id):
		# Shared behaviour for active effects
		if is_active:
			if active_effects[effect_id]["amount"] > 1:
				# Take one effect away from stack
				active_effects[effect_id]["amount"] -= 1
				active_effects[effect_id]["activated"] = false
				active_effects[effect_id]["time_left"] = active_effects[effect_id]["active_time"]
				# Call UI
				Global.emit_signal("call_ui_effect_amount_updated", effect_id, active_effects[effect_id]["amount"], is_active)
			else:
				# Remove effect if none is left after usage
				active_effects.erase(effect_id)
				# Call UI
				Global.emit_signal("call_ui_effect_removed", effect_id, is_active)
		# For passive effects
		else:
			if passive_effects[effect_id]["amount"] > 1:
				# Take one effect away from stack
				passive_effects[effect_id]["amount"] -= 1
				# Call UI
				Global.emit_signal("call_ui_effect_amount_updated", effect_id, passive_effects[effect_id]["amount"], is_active)
			else:
				# Remove effect if none is left after usage
				passive_effects.erase(effect_id)
				# Call UI
				Global.emit_signal("call_ui_effect_removed", effect_id, is_active)

func _on_active_tick(active_timer: Timer, effect_id: String):
	# Subtract time
	active_effects[effect_id]["time_left"] -= 1
	active_timer.start()
	
	# Call UI
	Global.emit_signal("call_ui_effect_time_update", effect_id, str(int(active_effects[effect_id]["time_left"])) + "s")
	
	target.sound.play_sound("effect_tick", &"Sound", false, -10.0)
	
	# Deactivate the effect on timeout
	if active_effects[effect_id]["time_left"] == 0:
		active_timer.queue_free()
		deactivate(effect_id, true)

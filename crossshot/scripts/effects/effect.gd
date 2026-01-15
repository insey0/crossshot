# Effect base class
class_name Effect
extends Node

# The ID of this effect
var effect_id: String
# The index of effect entry in one of the 'effects' array in the EffectManager
var effect_number: int

# The effect's type, can be active (true) or passive (false)
@export var is_active: bool
@export var active_time: float
@export var cooldown_time: float
@export var max_uses: int

@export var display_icon: Texture2D
@export var display_name: String
@export var description: String

var is_cooldown_active: bool
var uses_left: int

func activate(target: Entity):
	# Return when activated during the cooldown
	if is_cooldown_active:
		return

	if is_active:
		# Start countdown until effect deactivation
		# Create the timer
		var active_timer := Timer.new()
		add_child(active_timer)
		active_timer.one_shot = true
		active_timer.wait_time = active_time
		# Connect the timeout signal
		active_timer.connect("timeout", _on_active_timeout(active_timer, target))
		# Start the timer
		active_timer.start()

@warning_ignore("unused_parameter")
func deactivate(target: Entity):
	pass

func _on_active_timeout(timer: Timer, target: Entity):
	if uses_left > 1:
		# Substract one from use count and deactivate the effect
		uses_left -= 1
		deactivate(target)
		# Remove the timer
		timer.queue_free()
		
		# Start the cooldown
		if cooldown_time > 0:
			# Create the timer
			var cooldown_timer := Timer.new()
			add_child(cooldown_timer)
			cooldown_timer.one_shot = true
			cooldown_timer.wait_time = cooldown_time
			# Connect the timeout signal
			cooldown_timer.connect("timeout", _on_cooldown_timeout(cooldown_timer))
			# Start the timer
			cooldown_timer.start()
			# Set cooldown to active
			is_cooldown_active = true
	else:
		# Remove the effect
		queue_free()

func _on_cooldown_timeout(timer: Timer):
	# Set cooldown to inactive
	is_cooldown_active = false
	# Remove the timer
	timer.queue_free()

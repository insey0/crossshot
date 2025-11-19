extends TextureProgressBar

@export var bus: String
@export var percentage: Label

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_handle_click(event)
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		_handle_drag(event)

func _handle_click(event):
	if event.button_index == MOUSE_BUTTON_LEFT:
		_update_progress()

func _handle_drag(_event):
	_update_progress()

func _update_progress():
	var mouse_pos = get_local_mouse_position()
	var tex_size = texture_under.get_size()
	
	var progress = clampf(mouse_pos.x / tex_size.x, 0.0, 1.0)
	
	value = min_value + (progress * (max_value - min_value))
	percentage.text = str(int(value)) + "%"
	
	_update_volume()

func _update_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(value / 100.0))

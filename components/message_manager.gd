# Message Manager
class_name MessageManager
extends Node

@export var msg: RichTextLabel
@export var message_clear_timer: Timer
signal hidden()
var is_constant: bool = false

# Fixed dictionary of messages
var messages: Dictionary = {}

func _ready() -> void:
	messages = _load_data("res://data/messages.json")

func display(msg_key: String, values: Array, hide_after: float):
	var final_message: String
	if hide_after > 0.0:
		message_clear_timer.wait_time = hide_after
		message_clear_timer.start()
		is_constant = false
	else:
		is_constant = true

	if values != []:
		for value in values:
			final_message = messages[msg_key] % value
	else:
		final_message = messages[msg_key]
	msg.text = final_message

func hide():
	msg.text = ""
	hidden.emit()

func _load_data(path: String) -> Dictionary:
	var datafile = FileAccess.open(path, FileAccess.READ)
	if datafile == null:
		push_error("MessageManager: messages.json is missing")
		return {}
	var datatext = datafile.get_as_text()
	datafile.close()
	
	var data := JSON.new()
	var parsed_data = data.parse(datatext)
	if parsed_data != OK:
		push_error("MessageManager: JSON parsing error: " + data.get_error_message())
		return {}
	
	return data.data

func _on_message_clear_timer_timeout() -> void:
	if not is_constant:
		hide()

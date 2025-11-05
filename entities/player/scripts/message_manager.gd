class_name MessageManager
extends Node

@export var msg: RichTextLabel
@export var message_clear_timer: Timer
signal hidden()
var is_constant: bool = false

var messages: Dictionary = {
	"": "[i][color=#ADADAD]Empty message, nothing to display!",
	"heal": "[i][color=#00FF6A]Health +%d",
	"damage": "[i][color=#FF3B00]Health -%d",
	"death": "[b][i][color=#FF0043]Player was too weak for this world",
	"e_to_interact": "[color=#FFFFFF]'E' to interact with [b]%s",
	"picked_up": "[i][color=#00FF6A]Picked up [b]%s"
}

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

func _on_message_clear_timer_timeout() -> void:
	if not is_constant:
		hide()

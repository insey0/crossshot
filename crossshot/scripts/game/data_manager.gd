# Game Data Manager
class_name DataManager
extends Node

#Todo:
#save_game
#load_game

func load_json(path: String) -> Dictionary:
	var datafile = FileAccess.open(path, FileAccess.READ)
	if datafile == null:
		push_error("DataManager: ",path.get_basename(), " is missing")
		return {}
	var datatext = datafile.get_as_text()
	datafile.close()
	
	var data := JSON.new()
	var parsed_data = data.parse(datatext)
	if parsed_data != OK:
		push_error("DataManager: JSON parsing error: " + data.get_error_message())
		return {}
	return data.data

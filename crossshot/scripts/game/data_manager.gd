# Game Data Manager
class_name DataManager
extends Node

# Sound resources
var ext_sound_path: String = Global.audio_path
signal sounds_loaded # Signal to know when the sounds are loaded

func _ready() -> void:
	# Load all sound files into cache
	_load_external_sounds(ext_sound_path)

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

# Load external sound files
func _load_external_sounds(path: String) -> void:
	# Skip if sound_cache is already loaded
	if Global.audio_cache != {}:
		return

	# Directory
	var dir = DirAccess.open(path)
	var stream = null
	
	# Main loop
	if dir:
		for file in dir.get_files():
			if file.ends_with(".wav"):
				stream = AudioStreamWAV.load_from_file(path.path_join(file))
				Global.audio_cache[file.get_basename()] = stream
	sounds_loaded.emit()

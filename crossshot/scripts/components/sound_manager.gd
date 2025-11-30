class_name SoundManager
extends Node

@export var player: AudioStreamPlayer2D
@export var amb_player: AudioStreamPlayer2D
@export var entity_path: String
var sounds: Dictionary = {}

func _ready() -> void:
	_load_sounds("res://entities/")
	_load_sounds(entity_path)

func emit_sound(id: String, bus: StringName = &"Sound", vol: float = 0.0, random_pitch: bool = false, min_pitch: float = 0.0, std_max_pitch: float = 1.0):
	player.stream = sounds[id]
	player.bus = bus
	player.volume_db = vol
	if random_pitch:
		player.pitch_scale = randf_range(min_pitch, std_max_pitch)
	else:
		player.pitch_scale = std_max_pitch
	player.play()

# Sound loader
func _load_sounds(path: String):
	var dir_path = path.path_join("sounds") # Getting the directory of the current scene
	var dir = DirAccess.open(dir_path) # Opening the directory
	
	# Error handle
	if dir == null:
		push_error("SoundManager: Cannot open sounds directory: " + dir_path)
		return
	
	dir.list_dir_begin() # Entering the loop in the opened directory
	var elem_name = dir.get_next() # Iterating through the directory elements
	
	while elem_name != "":
		if not dir.current_is_dir() and elem_name.get_extension().to_lower() in ["tres", "wav", "mp3", "ogg"]:
			var sound_path = dir_path.path_join(elem_name) # Adding filename to the "sounds" directory path
			var sound_name = elem_name.get_basename() # Getting the file name only ("filename.wav" >>> "filename")
			
			var sound_resource = load(sound_path) # Loading the path as a resource
			if sound_resource and sound_resource is AudioStream:
				sounds[sound_name] = sound_resource # Adding to the cache
			# Error handle
			else:
				push_error("SoundManager: Failed to load sound: " + sound_path)
		elem_name = dir.get_next()
	dir.list_dir_end()

func _on_ambiance_player_finished() -> void:
	amb_player.play()

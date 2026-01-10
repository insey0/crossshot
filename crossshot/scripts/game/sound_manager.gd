# Sound Component
class_name SoundManager
extends Node

var sound_cache: Dictionary = {} # AudioStreams cache

var ext_path: String = Global.audio_path
var active_players: Array = [] # Current AudioStreamPlayer'ы
var max_players: int = 10

signal sounds_loaded # Signal to know when the sounds are loaded

func _ready() -> void:
	# Load all sound files into cache
	_load_external_sounds(ext_path)

# Play sound function
func play_sound(sound_name: String, bus: StringName = &"Sound", loop: bool = false,
volume_db: float = 0.0, pitch_scale: float = 1.0, start_from: float = 0.0) -> void:
	if not sound_cache.has(sound_name):
		push_error("SoundComponent: Couldn't find ", sound_name, " in sounds cache.")
	
	else:
		var player = AudioStreamPlayer2D.new()
		player.stream = sound_cache[sound_name]
		player.volume_db = volume_db
		player.pitch_scale = pitch_scale
		player.bus = bus
	
		player.finished.connect(_on_player_finished.bind(player, loop))
	
		get_parent().add_child(player)
		player.play(start_from) # Play sound from a specific moment
	
		active_players.append(player) # Adding to active ASP array
	
		cleanup_player_pool()

# Load external sound files
func _load_external_sounds(path: String) -> void:
	# Skip if sound_cache is already loaded
	if sound_cache != {}:
		return

	# Directory
	var dir = DirAccess.open(path)
	var stream = null
	
	# Main loop
	if dir:
		for file in dir.get_files():
			if file.ends_with(".wav"):
				stream = AudioStreamWAV.load_from_file(path.path_join(file))
				sound_cache[file.get_basename()] = stream
	sounds_loaded.emit()
	
# Clear all silent ASPs from active_players[]
func cleanup_player_pool() -> void:
	if active_players.size() > max_players:
		var to_remove: Array = [] # List of indexes of elements to delete
		for i in range(active_players.size()):
			var player: AudioStreamPlayer2D = active_players[i]
			if not player or not player.playing:
				to_remove.append(i)

		to_remove.reverse()
		for n in to_remove:
			var player: AudioStreamPlayer2D = active_players[n]
			if player and is_instance_valid(player):
				player.queue_free()
			active_players.remove_at(n)

# Check if the specific sound is playing
func is_sound_playing(sound_name: String) -> bool:
	for player in active_players:
		if player and player.stream == sound_cache.get(sound_name) and player.playing:
			return true
	return false

# Stop all active ASPs
func stop_all_sounds() -> void:
	for player: AudioStreamPlayer in active_players:
		if player and is_instance_valid(player):
			player.stop()
			player.queue_free()
		active_players.clear()

# Loop or auto-remove ASPs
func _on_player_finished(player: AudioStreamPlayer2D, loop: bool) -> void:
	if not loop:
		player.stop()
		if player and is_instance_valid(player) and not player.playing:
			active_players.erase(player)
			player.queue_free()
			return
	
	player.play()

# Clear cache and stop all sounds
func clear_cache() -> void:
	stop_all_sounds()
	sound_cache.clear()

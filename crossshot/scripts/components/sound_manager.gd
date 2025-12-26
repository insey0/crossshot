# Sound Manager
class_name SoundManager
extends Node

var sound_cache: Dictionary = {} # Кэш звуков

var ext_path: String = "user://audio/"
var active_players: Array = [] # Текущие AudioStreamPlayer'ы
var max_players: int = 10

# signal sounds_loaded

func _ready() -> void:
	# Загрузка звуковых файлов в кэш
	_load_external_sounds(ext_path)

# Функция проигрывания звука
func play_sound(sound_name: String, bus: StringName = &"Sound", loop: bool = false,
volume_db: float = 0.0, pitch_scale: float = 1.0, start_from: float = 0.0) -> void:
	if not sound_cache.has(sound_name):
		push_error("SoundManager: Couldn't find ", sound_name, " in sounds cache.")
	
	else:
		var player = AudioStreamPlayer2D.new()
		player.stream = sound_cache[sound_name]
		player.volume_db = volume_db
		player.pitch_scale = pitch_scale
		player.bus = bus
	
		player.finished.connect(_on_player_finished.bind(player, loop)) # Подключение сигнала завершения звука
	
		get_parent().add_child(player)
		player.play(start_from) # Проигрывание звука с конкретной секунды
	
		active_players.append(player) # Добавление в активные ASP
	
		cleanup_player_pool()

func _load_external_sounds(path: String):
	# Директория
	var dir = DirAccess.open(path)
	var stream = null
	
	if dir:
		for file in dir.get_files():
			if file.ends_with(".wav"):
				stream = AudioStreamWAV.load_from_file(path.path_join(file))
				sound_cache[file.get_basename()] = stream
	
# Удаление неиспользуемых ASP из active_players[]
func cleanup_player_pool() -> void:
	if active_players.size() > max_players:
		var to_remove: Array = [] # Список индексов элементов для удаления
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

# Проверка проигрывания звука
func is_sound_playing(sound_name: String) -> bool:
	for player in active_players:
		if player and player.stream == sound_cache.get(sound_name) and player.playing:
			return true
	return false

# Остановка всех звуков
func stop_all_sounds() -> void:
	for player: AudioStreamPlayer in active_players:
		if player and is_instance_valid(player):
			player.stop()
			player.queue_free()
		active_players.clear()

# Автоудаление или зацикливание ASP
func _on_player_finished(player: AudioStreamPlayer2D, loop: bool) -> void:
	if not loop:
		player.stop()
		if player and is_instance_valid(player) and not player.playing:
			active_players.erase(player)
			player.queue_free()
			return
	
	player.play()

# Очистить кэш
func unload_cache() -> void:
	stop_all_sounds()
	sound_cache.clear()

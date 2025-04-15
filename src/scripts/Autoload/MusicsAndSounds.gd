extends Node

var music_player: AudioStreamPlayer
var sound_player: AudioStreamPlayer

const menu_music = preload("res://assets/sounds/menu.mp3")
const game_music = preload("res://assets/sounds/game.mp3")

var music_volume: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.name = "MusicPlayer"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	sound_player = AudioStreamPlayer.new()
	sound_player.bus = "Sound"
	sound_player.name = "SoundPlayer"
	
	add_child(music_player)
	#add_child(sound_player)
	update_music_volume()
	
func update_music_volume() -> void:
	music_volume = clamp(Global.settings.music, 0.0, 10.0)
	# Конвертируем 0-10 в диапазон -80 dB до 0 dB
	var db = linear_to_db(music_volume / 10.0) if music_volume > 0 else -80.0
	music_player.volume_db = db

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameDay.stages_game.current_stage == StagesGame.Stage.MENU and \
	music_player.stream != menu_music or not music_player.playing:
		print(1)
		music_player.stop()
		music_player.stream = menu_music
		music_player.play()
	elif GameDay.stages_game.current_stage != StagesGame.Stage.MENU and \
	music_player.stream != game_music or not music_player.playing:
		print(2)
		music_player.stop()
		music_player.stream = game_music
		music_player.play()

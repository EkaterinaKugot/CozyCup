extends Node

var music_player: AudioStreamPlayer
var sound_player: AudioStreamPlayer
var client_player: AudioStreamPlayer
var timer_player: AudioStreamPlayer
var coffee_player: AudioStreamPlayer
var milk_player: AudioStreamPlayer

const sounds = {
	"menu_music": preload("res://assets/sounds/menu.mp3"),
	"game_music": preload("res://assets/sounds/game.mp3"),
	"button_click": preload("res://assets/sounds/button_click.MP3"),
	"client": preload("res://assets/sounds/client.MP3"),
	"liquid": preload("res://assets/sounds/liquid.MP3"),
	"coffee": preload("res://assets/sounds/coffee.MP3"),
	"milk": preload("res://assets/sounds/milk.MP3"),
	"syrup": preload("res://assets/sounds/syrup.MP3"),
	"sugar": preload("res://assets/sounds/sugar.MP3"),
	"timer": preload("res://assets/sounds/timer.MP3"),
	"pay": preload("res://assets/sounds/pay.MP3"),
}

var music_volume: float
var sound_volume: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	sound_player = AudioStreamPlayer.new()
	sound_player.bus = "Sound"
	
	coffee_player = AudioStreamPlayer.new()
	coffee_player.bus = "Sound"
	
	milk_player = AudioStreamPlayer.new()
	milk_player.bus = "Sound"
	
	timer_player = AudioStreamPlayer.new()
	timer_player.bus = "Sound"
	
	client_player = AudioStreamPlayer.new()
	client_player.bus = "Sound"
	
	add_child(music_player)
	add_child(sound_player)
	add_child(coffee_player)
	add_child(milk_player)
	add_child(timer_player)
	add_child(client_player)
	
	update_music_volume()
	update_sound_volume()
	
	get_tree().node_added.connect(_on_node_added)
	
func _on_node_added(node: Node) -> void:
	if node is Button:
		node.pressed.connect(play_sound.bind(sound_player, "button_click"))

func play_sound(player: AudioStreamPlayer, name_sound: String) -> void:
	if player.playing:
		player.stop()
	
	if name_sound != "" and sounds.has(name_sound):
		player.stream = sounds[name_sound]
		player.play()
		
func update_music_volume() -> void:
	music_volume = clamp(Global.settings.music, 0.0, 10.0)
	# Конвертируем 0-10 в диапазон -80 dB до 0 dB
	var db = linear_to_db(music_volume / 10.0) if music_volume > 0 else -80.0
	music_player.volume_db = db
	
func update_sound_volume() -> void:
	sound_volume = clamp(Global.settings.sounds, 0.0, 10.0)
	# Конвертируем 0-10 в диапазон -80 dB до 0 dB
	var db = linear_to_db(sound_volume / 10.0) if sound_volume > 0 else -80.0
	sound_player.volume_db = db
	coffee_player.volume_db = db
	milk_player.volume_db = db
	timer_player.volume_db = db
	client_player.volume_db = db

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameDay.stages_game.current_stage == StagesGame.Stage.MENU and \
	music_player.stream != sounds["menu_music"] or not music_player.playing:
		music_player.stop()
		music_player.stream = sounds["menu_music"]
		music_player.play()
	elif GameDay.stages_game.current_stage != StagesGame.Stage.MENU and \
	music_player.stream != sounds["game_music"] or not music_player.playing:
		music_player.stop()
		music_player.stream = sounds["game_music"]
		music_player.play()

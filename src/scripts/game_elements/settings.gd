extends Control

@onready var music_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Music/MusicButton
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Music/MusicSlider
@onready var numder_music: Label = $PanelContainer/MarginContainer/VBoxContainer/Music/NumderMusic

@onready var sound_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Sound/SoundButton
@onready var sound_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sound/SoundSlider
@onready var number_sound: Label = $PanelContainer/MarginContainer/VBoxContainer/Sound/NumberSound

@onready var cancel: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Cancel
@onready var apply: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Apply

signal cancel_pressed
signal apply_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	music_slider.value = Global.settings.music
	sound_slider.value = Global.settings.sounds
	music_slider_changed(0)
	sound_slider_changed(0)
	
	music_button.pressed.connect(on_music_pressed)
	music_slider.drag_ended.connect(music_slider_changed)
	
	sound_button.pressed.connect(on_sound_pressed)
	sound_slider.drag_ended.connect(sound_slider_changed)
	
	cancel.pressed.connect(on_cancel_pressed)
	apply.pressed.connect(on_apply_pressed)
	
func on_music_pressed() -> void:
	if music_button.button_pressed:
		music_slider.value = music_slider.min_value
	else:
		music_slider.value += music_slider.step
		
	numder_music.text = str(music_slider.value)
	
	Global.settings.change_music(music_slider.value)
	Audio.update_music_volume()

func music_slider_changed(_value: float) -> void:
	numder_music.text = str(music_slider.value)
	if music_slider.value == music_slider.min_value:
		music_button.button_pressed = true
	elif music_button.button_pressed:
		music_button.button_pressed = false
	
	Global.settings.change_music(music_slider.value)
	Audio.update_music_volume()
	
func on_sound_pressed() -> void:
	if sound_button.button_pressed:
		sound_slider.value = sound_slider.min_value
	else:
		sound_slider.value += sound_slider.step
		
	number_sound.text = str(sound_slider.value)
	
	Global.settings.change_sounds(sound_slider.value)
	Audio.update_sound_volume()
	
func sound_slider_changed(_value: float) -> void:
	number_sound.text = str(sound_slider.value)
	if sound_slider.value == sound_slider.min_value:
		sound_button.button_pressed = true
	elif sound_button.button_pressed:
		sound_button.button_pressed = false
		
	Global.settings.change_sounds(sound_slider.value)
	Audio.update_sound_volume()

func on_cancel_pressed() -> void:
	get_tree().paused = false
	cancel_pressed.emit()

func on_apply_pressed() -> void:
	get_tree().paused = false
	apply_pressed.emit()

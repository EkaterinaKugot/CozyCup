extends Control

@onready var exit = $MarginContainer/VBoxContainer/Exit as Button
@onready var recipes: Button = $MarginContainer/VBoxContainer/Recipes
@onready var settings: Button = $MarginContainer/VBoxContainer/Settings

var scene_settings = preload("res://src/scenes/game_elements/settings.tscn")
var instance_settings

var scene_confirmation_exit = preload("res://src/scenes/game_elements/action_confirmation.tscn")
var instance_confirmation_exit
var text = "Вы действительно хотите выйти? Весь прогресс за пройденный день будет сброшен."

func _ready() -> void:
	set_process(false)
	exit.pressed.connect(on_exit_pressed)
	recipes.pressed.connect(on_recipes_pressed)
	settings.pressed.connect(on_settings_pressed)

func on_settings_pressed() -> void:
	instance_settings = scene_settings.instantiate()
	instance_settings.connect("cancel_pressed", on_cancel_pressed)
	instance_settings.connect("apply_pressed", on_apply_pressed)
	get_tree().root.add_child(instance_settings)

func on_cancel_pressed() -> void:
	if instance_settings != null:
		instance_settings.queue_free()
	Global.load_settings()
	Audio.update_music_volume()
	Audio.update_sound_volume()

func on_apply_pressed() -> void:
	if instance_settings != null:
		instance_settings.queue_free()
	Global.save_settings()
	
func on_recipes_pressed() -> void:
	GameDay.current_scene = get_tree().current_scene.name
	get_tree().change_scene_to_file("res://src/scenes/book_recipes.tscn")
	
func on_exit_pressed() -> void:
	if GameDay.stages_game.current_stage == StagesGame.Stage.STATISTIC:
		go_to_menu()
	elif GameDay.stages_game.current_stage != StagesGame.Stage.MENU:
		instance_confirmation_exit = scene_confirmation_exit.instantiate()
		instance_confirmation_exit.connect("no_pressed", _on_no_pressed)
		instance_confirmation_exit.connect("yes_pressed", _on_yes_pressed)
		instance_confirmation_exit.get_node(
			"PanelContainer/MarginContainer/VBoxContainer/Text"
		).text = text
		get_parent().add_child(instance_confirmation_exit)
	else:
		Global.save_progress()
		get_tree().quit()

func _on_no_pressed() -> void:
	if instance_confirmation_exit != null:
		instance_confirmation_exit.queue_free()

func _on_yes_pressed() -> void:
	if instance_confirmation_exit != null:
		instance_confirmation_exit.queue_free()
	
	Global.load_progress()
	go_to_menu()

func go_to_menu() -> void:
	GameDay.start_menu_stage()
	GameDay.clean_variables()
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")

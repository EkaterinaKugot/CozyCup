extends Control

@onready var exit = $MarginContainer/VBoxContainer/Exit as Button

var scene_confirmation_exit = preload("res://src/scenes/game_elements/action_confirmation.tscn")
var instance_confirmation_exit
var text = "Вы действительно хотите выйти? Весь прогресс за пройденный день будет сброшен."

func _ready() -> void:
	set_process(false)
	exit.pressed.connect(on_exit_pressed)
	$MarginContainer/VBoxContainer/Recipes.pressed.connect(print_recipe)

func print_recipe() -> void:
	print("Recipe")
	
func on_exit_pressed() -> void:
	if get_tree().current_scene.name != "Menu":
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
	
	GameDay.clean_variables()
	Global.load_progress()
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")

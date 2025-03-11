extends Control

@onready var exit = $MarginContainer/VBoxContainer/Exit as Button

func _ready() -> void:
	set_process(false)
	exit.pressed.connect(on_exit_pressed)
	$MarginContainer/VBoxContainer/Recipes.pressed.connect(print_recipe)

func print_recipe() -> void:
	print("Recipe")
	
func on_exit_pressed() -> void:
	if get_tree().current_scene.name != "Menu":
		GameDay.end_game_day()
		get_tree().change_scene_to_file("res://src/scenes/menu.tscn")
	else:
		Global.save_progress()
		get_tree().quit()

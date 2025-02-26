extends Control

@onready var exit = $MarginContainer/VBoxContainer/Exit as Button

func _ready() -> void:
	set_process(false)
	exit.pressed.connect(on_exit_pressed)
	$MarginContainer/VBoxContainer/Recipes.pressed.connect(print_recipe)

func print_recipe() -> void:
	print("Recipe")
	
func on_exit_pressed() -> void:
	Global.save_progress()
	get_tree().quit()

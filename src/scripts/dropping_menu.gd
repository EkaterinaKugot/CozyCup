extends Control


func _ready() -> void:
	set_process(false)
	$MarginContainer/VBoxContainer/Recipes.pressed.connect(print_recipe)

func print_recipe() -> void:
	print("Recipe")

extends Button


func _on_pressed() -> void:
	CoffeeCup.current_topping = null
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")

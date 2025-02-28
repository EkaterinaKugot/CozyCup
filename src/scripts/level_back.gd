extends Control

signal level_hud_visible()

var coffee_machine = CoffeeMachine.new()

func _ready() -> void:
	emit_signal("level_hud_visible")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")


func _on_coffee_machine_coffee_machine_pressed() -> void:
	coffee_machine.number_grains += 1

func _on_milk_frother_milk_frother_pressed() -> void:
	pass

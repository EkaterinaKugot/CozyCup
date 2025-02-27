extends Control

@onready var start_new_day = $MarginFooter/Footer/Start as Button

signal level_hud_invisible()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("level_hud_invisible")
	start_new_day.pressed.connect(on_start_pressed)
	start_new_day.text = str(Global.progress.day) + " день"
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")

extends Control

@onready var start_new_day = $MarginFooter/Footer/Start as Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_new_day.pressed.connect(on_start_pressed)
	start_new_day.text = str(Global.progress.day) + " день"
	
func on_start_pressed() -> void:
	GameDay.start_purchase_stage()
	Global.save_progress()
	get_tree().change_scene_to_file("res://src/scenes/purchase.tscn")

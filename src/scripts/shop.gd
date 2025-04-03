extends Control

@onready var close: Button = $MarginContainer2/Close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close.pressed.connect(on_close_pressed)

func on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

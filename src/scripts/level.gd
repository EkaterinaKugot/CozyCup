extends Control

@onready var client_dialog: Control = $ClientDialog
@onready var bottom_hud: CanvasLayer = $BottomHud

func _ready() -> void:
	bottom_hud.hide_button("right")


func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_back.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")

extends Control

@onready var ok: Button = $Panel/PanelContainer/MarginContainer/VBoxContainer/Ok

signal ok_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	ok.pressed.connect(on_ok_pressed)

func on_ok_pressed() -> void:
	get_tree().paused = false
	ok_pressed.emit()

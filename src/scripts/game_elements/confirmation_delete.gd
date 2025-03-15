extends Control

@onready var no: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/No
@onready var yes: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Yes

signal no_pressed
signal yes_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	no.pressed.connect(on_no_pressed)
	yes.pressed.connect(on_yes_pressed)
	
func on_no_pressed() -> void:
	get_tree().paused = false
	no_pressed.emit()
	
func on_yes_pressed() -> void:
	get_tree().paused = false
	yes_pressed.emit()

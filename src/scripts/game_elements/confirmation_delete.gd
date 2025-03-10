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
	no_pressed.emit()
	get_tree().paused = false
	
func on_yes_pressed() -> void:
	CoffeeCup.clean_coffee_cup()
	yes_pressed.emit()
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

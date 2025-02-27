extends CanvasLayer

@onready var left_button = $FooterControl/MarginContainer/Left as Button
@onready var back_button = $FooterControl/MarginContainer/Back as Button
@onready var right_button = $FooterControl/MarginContainer/Right as Button

signal left_button_pressed()
signal back_button_pressed()
signal right_button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_button.pressed.connect(on_left_pressed)
	back_button.pressed.connect(on_back_pressed)
	right_button.pressed.connect(on_right_pressed)

func on_left_pressed() -> void:
	emit_signal("left_button_pressed")
	
func on_back_pressed() -> void:
	emit_signal("back_button_pressed")
	
func on_right_pressed() -> void:
	emit_signal("right_button_pressed")

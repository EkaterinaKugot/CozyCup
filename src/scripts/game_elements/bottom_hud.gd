extends CanvasLayer

@onready var left_button = $FooterControl/MarginContainer/Left as Button
@onready var back_button = $FooterControl/MarginContainer/Back as Button
@onready var right_button = $FooterControl/MarginContainer/Right as Button

signal left_button_pressed
signal back_button_pressed
signal right_button_pressed

var bottom_hud_disabled_two: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_button.pressed.connect(on_left_pressed)
	back_button.pressed.connect(on_back_pressed)
	right_button.pressed.connect(on_right_pressed)

func on_left_pressed() -> void:
	left_button_pressed.emit()
	
func on_back_pressed() -> void:
	back_button_pressed.emit()
	
func on_right_pressed() -> void:
	right_button_pressed.emit()
		
func hide_button(hide_name: String) -> void:
	if hide_name == "left":
		left_button.visible = false
		right_button.visible = true
		back_button.visible = true
	elif hide_name == "right":
		left_button.visible = true
		right_button.visible = false
		back_button.visible = true
	else:
		left_button.visible = true
		right_button.visible = true
		back_button.visible = false
		

func _disabled_bottom_hud() -> void:
	if left_button.disabled:
		bottom_hud_disabled_two = true
	left_button.disabled = true
	back_button.disabled = true
	right_button.disabled = true

func _undisabled_bottom_hud() -> void:
	if not bottom_hud_disabled_two:
		left_button.disabled = false
		back_button.disabled = false
		right_button.disabled = false
	else:
		bottom_hud_disabled_two = false

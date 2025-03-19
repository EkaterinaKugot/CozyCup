extends "res://src/scripts/items/base_coffee_cup.gd"

@onready var glow_effect = $GlowEffect
var item_pressed: bool = false

func _input_event(_viewport, event, _shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			item_pressed = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			item_pressed = true
	if item_pressed and GameDay.client != null and GameDay.client.order_accept:
		glow_effect.visible = not glow_effect.visible
		GameDay.coffe_cup.is_chosen = not GameDay.coffe_cup.is_chosen
		item_pressed = false

extends Area2D

signal milk_frother_pressed
		
func _ready() -> void:
	pass # Replace with function body.

func _input_event(_viewport, event, _shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			emit_signal("milk_frother_pressed")
	else:
		if event is InputEventMouseButton and event.pressed:
			print(event)
			emit_signal("milk_frother_pressed")

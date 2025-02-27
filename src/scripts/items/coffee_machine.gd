extends Area2D

signal coffee_machine_pressed
		
func _ready() -> void:
	pass # Replace with function body.

func _input_event(viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			emit_signal("coffee_machine_pressed")
	else:
		if event is InputEventMouseButton and event.pressed:
			print(event)
			emit_signal("coffee_machine_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

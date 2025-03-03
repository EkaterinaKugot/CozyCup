extends Sprite2D


func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print("CoffeeKettle ", event)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("CoffeeKettle ", event)
				
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

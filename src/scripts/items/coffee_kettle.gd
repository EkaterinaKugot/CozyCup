extends Area2D

var is_dragging = false  
var mouse_button_pressed = false
var drag_offset = Vector2()  
var initial_position = Vector2()

func _input_event(_viewport, event, shape_idx):
	if CoffeeMachine.coffee_is_ready and not $CoffeeKettleProgress.is_holding and \
	get_tree().root.get_node("LevelBack").current_ingredient == null and \
	(event is InputEventScreenTouch or event is InputEventMouseButton):
		if event.pressed:
			print("CoffeeKettle ", event)
			is_dragging = true 
			mouse_button_pressed = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			mouse_button_pressed = false
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		if mouse_button_pressed:
			global_position = get_global_mouse_position() + drag_offset
		else:
			is_dragging = false
			global_position = initial_position

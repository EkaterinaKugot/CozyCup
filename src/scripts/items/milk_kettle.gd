extends Area2D

var is_dragging = false  
var mouse_button_pressed = false
var drag_offset = Vector2()  
var initial_position = Vector2()

var is_overlapping = false
var current_area: Area2D

signal milk_delivered()

func _input_event(_viewport, event, _shape_idx):
	if GameDay.milk_frother.milk_is_ready and not $MilkKettleProgress.is_holding and \
	(event is InputEventScreenTouch or event is InputEventMouseButton):
		if event.pressed:
			print("MilkKettle ", event)
			is_dragging = true 
			mouse_button_pressed = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			mouse_button_pressed = false
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = global_position + Vector2(20, 0)
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	

func _process(_delta: float) -> void:
	if is_dragging:
		if mouse_button_pressed:
			global_position = get_global_mouse_position() + drag_offset
		else:
			is_dragging = false
			global_position = initial_position
			if current_area != null and current_area.name == "CoffeeCup":
				milk_delivered.emit()

# Срабатывает при входе в другую область
func _on_area_entered(area: Area2D):
	if area != self:  # Исключаем саму себя
		is_overlapping = true
		current_area = area

# Срабатывает при выходе из другой области
func _on_area_exited(area: Area2D):
	if area != self:
		is_overlapping = false
		current_area = null

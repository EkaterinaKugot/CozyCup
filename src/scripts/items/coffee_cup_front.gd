extends "res://src/scripts/items/base_coffee_cup.gd"

@onready var glow_effect = $GlowEffect
var item_pressed: bool = false

var is_dragging = false  
var mouse_button_pressed = false
var drag_offset = Vector2()  
var initial_position = Vector2()
var current_area: Area2D

signal order_is_given(cup: Area2D)

func _ready() -> void:
	display_ingredients()
	initial_position = global_position
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			is_dragging = true 
			mouse_button_pressed = true
			drag_offset = global_position - get_global_mouse_position()
			shadow.visible = false
		else:
			mouse_button_pressed = false
	

func _process(_delta: float) -> void:
	if is_dragging:
		if mouse_button_pressed:
			global_position = get_global_mouse_position() + drag_offset
		else:
			is_dragging = false
			global_position = initial_position
			shadow.visible = true
			if current_area != null and current_area.name == "AssetClient" and GameDay.client != null and \
			GameDay.client.order_accept:
				order_is_given.emit(self)
		
# Срабатывает при входе в другую область
func _on_area_entered(area: Area2D):
	if area != self:  # Исключаем саму себя
		current_area = area
		if current_area.name == "AssetClient" and GameDay.client != null and GameDay.client.order_accept:
			glow_effect.visible = true

# Срабатывает при выходе из другой области
func _on_area_exited(area: Area2D):
	if area != self:
		current_area = null
		glow_effect.visible = false

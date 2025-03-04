extends Area2D

@onready var glow_effect = $GlowEffect
@onready var number = $Number
var item_pressed: bool = false
var ingredient: Ingredient
var is_dragging: bool = false

signal ingredient_pressed(ingredient: Ingredient)

func _input_event(_viewport, event, _shape_idx):
	is_dragging = get_parent().get_node("CoffeeMachine").get_node("CoffeeKettle").is_dragging
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed and not is_dragging:
			item_pressed = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and \
		not is_dragging:
			item_pressed = true
			
	if item_pressed:
		item_pressed = false
		glow_effect.visible = not glow_effect.visible
		ingredient_pressed.emit(ingredient)
				
func update_number() -> void:
	number.text = str(Global.progress.opened_ingredients[ingredient])

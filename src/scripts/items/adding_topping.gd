extends Area2D

var item_pressed: bool = false
@onready var drink = $Drink

var scene_topping_top = preload("res://src/scenes/items/topping_top.tscn")
var ingredient: Ingredient
var number = 1

func _input_event(_viewport, event, _shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed :
			item_pressed = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			item_pressed = true
			
	if item_pressed:
		item_pressed = false
		if Global.progress.check_number_ingredient(ingredient, number):
			var instance = scene_topping_top.instantiate()
			instance.get_node("Topping").texture = load(
				"res://assets/items/topping_{0}.png".format([ingredient.id])
			)
			instance.position = Vector2(0, 0) + (event.position - position)
			
			add_child(instance)
			Global.progress.sub_number_ingredient(ingredient, number)
			CoffeeCup.add_ingredient(ingredient, number)
			CoffeeCup.add_topping(ingredient, instance.position)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window_size = get_viewport().size - Vector2i(60.0, 60.0)
	position = window_size / 2
	ingredient = CoffeeCup.current_topping
	
	var assets: String = "res://assets/items/coffee_cup_top.png"
	if CoffeeCup.check_has_category(Ingredient.Category.MILK) or \
	CoffeeCup.check_has_category(Ingredient.Category.CREAM):
		assets = "res://assets/items/coffee_cup_milk.png"
	elif CoffeeCup.check_has_category(Ingredient.Category.GRAINS):
		assets = "res://assets/items/coffee_cup_grains.png"
	elif CoffeeCup.check_has_category(Ingredient.Category.WATER):
		assets = "res://assets/items/coffee_cup_water.png"
	drink.texture = load(assets)
	
	for ing in CoffeeCup.added_topping.keys():
		for pos in CoffeeCup.added_topping[ing]:
			var instance = scene_topping_top.instantiate()
			instance.get_node("Topping").texture = load(
				"res://assets/items/topping_{0}.png".format([ing.id])
			)
			instance.position = pos
			add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

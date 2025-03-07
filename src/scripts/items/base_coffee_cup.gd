extends Area2D

var coffee_cup_ingredient = preload("res://src/scenes/game_elements/coffee_cup_ingredient.tscn")
var dict_instance: Dictionary = {}

func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category != Ingredient.Category.GRAINS and \
			current_ingredient.category != Ingredient.Category.MILK:
				add_ingredient(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category != Ingredient.Category.GRAINS and \
			current_ingredient.category != Ingredient.Category.MILK:
				add_ingredient(current_ingredient)
				
func add_ingredient(current_ingredient: Ingredient) -> void:
	CoffeeCup.add_ingredient(
		current_ingredient, 1
	) # добавили в кружку
	
	display_ingredients()  # отображаем ингредиенты
	
func display_ingredients() -> void:
	var array_ingredients = CoffeeCup.array_ingredients() 
	var y = 50
	for ingredient in array_ingredients: # отображаем добавленное
		var instance_coffee_cup_ingredient
		if ingredient in dict_instance.keys():
			instance_coffee_cup_ingredient = dict_instance[ingredient]
		else:
			instance_coffee_cup_ingredient = coffee_cup_ingredient.instantiate()
			var icon = instance_coffee_cup_ingredient.get_node("Icon") # добавляем иконку
			icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
			instance_coffee_cup_ingredient.position = Vector2(55, y) # устанавливаем позицию
			
			add_child(instance_coffee_cup_ingredient)
			
		var label_number = instance_coffee_cup_ingredient.get_node("Number") # обновляем количество
		label_number.text = str(CoffeeCup.added_ingredients[ingredient])
		
		dict_instance[ingredient] = instance_coffee_cup_ingredient
		y -= 30
	print("array_ingredients: ", array_ingredients)
	print("dict_instance: ", dict_instance)

extends Area2D

var coffee_cup_ingredient = preload("res://src/scenes/game_elements/coffee_cup_ingredient.tscn")
var dict_instance: Dictionary = {}

func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category != Ingredient.Category.GRAINS and \
			current_ingredient.category != Ingredient.Category.MILK and \
			current_ingredient.category != Ingredient.Category.SYRUP:
				add_ingredient(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category != Ingredient.Category.GRAINS and \
			current_ingredient.category != Ingredient.Category.MILK and \
			current_ingredient.category != Ingredient.Category.SYRUP:
				add_ingredient(current_ingredient)
				
func add_ingredient(current_ingredient: Ingredient) -> void:
	var number = 1
	if Global.progress.check_number_ingredient(current_ingredient, number):
		if current_ingredient.category == Ingredient.Category.TOPPING:
			CoffeeCup.current_topping = current_ingredient
			get_tree().change_scene_to_file("res://src/scenes/adding_topping.tscn")
		else:
			CoffeeCup.add_ingredient(
				current_ingredient, 1
			) # добавили в кружку
			
			if current_ingredient.category != Ingredient.Category.WATER:
				Global.progress.sub_number_ingredient(current_ingredient, number) # обновили progress
				get_parent().instances_ingredients[
					current_ingredient.category
					][current_ingredient].update_number() # визуально обновили значение у ингредиента
			
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

func clean_dict_instance() -> void:
	for ingredient in dict_instance.keys():
		if dict_instance[ingredient] != null:
			dict_instance[ingredient].queue_free()
	dict_instance = {}
	
func _ready() -> void:
	display_ingredients()

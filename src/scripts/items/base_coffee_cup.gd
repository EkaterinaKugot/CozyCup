extends Area2D

var coffee_cup_ingredient = preload("res://src/scenes/game_elements/coffee_cup_ingredient.tscn")
var added_instance: Array[Dictionary] = []
var pos_y: int = 55

@onready var asset_cup: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $Shadow

func _input_event(_viewport, event, _shape_idx):
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
			GameDay.coffe_cup.current_topping = current_ingredient
			get_tree().change_scene_to_file("res://src/scenes/adding_topping.tscn")
		else:
			GameDay.coffe_cup.add_ingredient(
				current_ingredient, 1
			) # добавили в кружку
			
			if current_ingredient.category != Ingredient.Category.WATER:
				Global.progress.sub_number_ingredient(current_ingredient, number) # обновили progress
				get_parent().instances_ingredients[
					current_ingredient.category
					][current_ingredient].update_number() # визуально обновили значение у ингредиента
				if current_ingredient.category == Ingredient.Category.SUGAR:
					Audio.play_sound(Audio.sound_player, "sugar")
			else:
				Audio.play_sound(Audio.sound_player, "liquid")
			
			display_ingredients()  # отображаем ингредиенты
	
func display_ingredients() -> void:
	_display_drink()
	var instance_coffee_cup_ingredient
	if added_instance.size() == 0: # первое отображение на сцене
		for element in GameDay.coffe_cup.added_ingredients:
			var ingredient = element.keys()[0]
			instance_coffee_cup_ingredient = create_new_instance(ingredient)
			
			var label_number = instance_coffee_cup_ingredient.get_node("Number") # обновляем количество
			label_number.text = str(element[ingredient])
	else: # повторное обновление на сцене
		# Проверяем, добавлен новый ингредиент или обновлено количество у старого
		if GameDay.coffe_cup.added_ingredients.size() == added_instance.size(): # обновлено количество у старого
			instance_coffee_cup_ingredient = added_instance[-1].values()[0]
		elif GameDay.coffe_cup.added_ingredients.size() - added_instance.size() == 1: # добавлен новый
			var ingredient = GameDay.coffe_cup.added_ingredients[-1].keys()[0]
			instance_coffee_cup_ingredient = create_new_instance(ingredient)
		else: # ошибка
			push_error("Error display of ingredients in a cup")
			
		if instance_coffee_cup_ingredient != null:
			var label_number = instance_coffee_cup_ingredient.get_node("Number") # обновляем количество
			label_number.text = str(GameDay.coffe_cup.added_ingredients[-1].values()[0])

func _display_drink() -> void:
	var assets: String = "res://assets/items/cofee_cup.png"
	if GameDay.coffe_cup.check_has_category(Ingredient.Category.MILK) or \
	GameDay.coffe_cup.check_has_category(Ingredient.Category.CREAM):
		assets = "res://assets/items/cofee_cup_milk.png"
	elif GameDay.coffe_cup.check_has_category(Ingredient.Category.GRAINS):
		assets = "res://assets/items/cofee_cup_coffee.png"
		if GameDay.coffe_cup.check_has_category(Ingredient.Category.ICE_CREAM):
			assets = "res://assets/items/cofee_cup_ice_cream.png"
	elif GameDay.coffe_cup.check_has_category(Ingredient.Category.WATER):
		assets = "res://assets/items/cofee_cup_water.png"
	asset_cup.texture = load(assets)
	
func create_new_instance(ingredient: Ingredient):
	var instance_coffee_cup_ingredient = coffee_cup_ingredient.instantiate()
			
	var icon = instance_coffee_cup_ingredient.get_node("Icon") # добавляем иконку
	icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
			
	instance_coffee_cup_ingredient.position = Vector2(70, pos_y) # устанавливаем позицию
			
	pos_y -= 30 # обновляем позицию для следующего ингредиента
	
	added_instance.append({ingredient: instance_coffee_cup_ingredient})
	add_child(instance_coffee_cup_ingredient)
	return instance_coffee_cup_ingredient
			
func clean_added_instance() -> void:
	for element in added_instance:
		var instance = element.values()[0]
		if instance != null:
			instance.queue_free()
	added_instance = []
	pos_y = 55
	
func _ready() -> void:
	display_ingredients()

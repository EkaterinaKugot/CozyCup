extends Node

var added_ingredients: Dictionary:
	get:
		return added_ingredients
	set(value):
		added_ingredients = value
var added_topping: Dictionary:
	get:
		return added_topping
	set(value):
		added_topping = value
var current_topping: Ingredient:
	get:
		return current_topping
	set(value):
		current_topping = value

func add_ingredient(ingredient: Ingredient, number: int) -> void:
	var has_ingredient = false
	for ing in added_ingredients.keys():
		if ing == ingredient:
			added_ingredients[ingredient] += number
			has_ingredient = true
			break
			
	if not has_ingredient:
		added_ingredients[ingredient] = number
		

func array_ingredients() -> Array:
	return Array(added_ingredients.keys())
	
func add_topping(ingredient: Ingredient, position: Vector2):
	if ingredient in added_topping.keys():
		added_topping[ingredient].append(position)
	else:
		added_topping[ingredient] = [position]
		
func clean_coffee_cup() -> void:
	added_ingredients = {}
	added_topping = {}
	current_topping = null

func check_has_category(category) -> bool:
	for ing in added_ingredients.keys():
		if ing.category == category:
			return true
	return false

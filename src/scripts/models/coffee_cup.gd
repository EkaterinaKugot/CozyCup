class_name CoffeeCup

var added_ingredients: Array[Dictionary]:
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
var is_chosen: bool = false

func add_ingredient(ingredient: Ingredient, number: int) -> void:
	if added_ingredients.size() != 0 and added_ingredients[-1].keys()[0] == ingredient:
		added_ingredients[-1][ingredient] += number
	else:
		added_ingredients.append({ingredient: number})
	
func add_topping(ingredient: Ingredient, position: Vector2):
	if ingredient in added_topping.keys():
		added_topping[ingredient].append(position)
	else:
		added_topping[ingredient] = [position]
		
func clean_coffee_cup() -> void:
	added_ingredients = []
	added_topping = {}
	current_topping = null

func check_has_category(category) -> bool:
	for i in added_ingredients:
		var ing = i.keys()[0]
		if ing.category == category:
			return true
	return false

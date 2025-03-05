extends Node

var added_ingredients: Dictionary:
	get:
		return added_ingredients
	set(value):
		added_ingredients = value
		
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

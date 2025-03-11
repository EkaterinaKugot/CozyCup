extends Node
class_name Order

@export var recipe: Recipe:
	get:
		return recipe
	set(value):
		recipe = value
		
@export var step_ingredient: Dictionary:
	get:
		return step_ingredient
	set(value):
		step_ingredient = value

func add_ingredient(ingredient: Ingredient, number: int) -> void:
	step_ingredient[ingredient] = number

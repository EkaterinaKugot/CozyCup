# recipe.gd
extends Resource
class_name Recipe

@export var id: String:
	get:
		return id
@export var name: String:
	get:
		return name
@export_multiline var description: String:
	get:
		return description
@export var is_basic: bool:
	get:
		return is_basic
@export var ingredients: Dictionary = {
	Ingredient.Category.MILK: 0,
	Ingredient.Category.CREAM: 0,
	Ingredient.Category.GRAINS: 0,
	Ingredient.Category.SYRUP: 0,
	Ingredient.Category.TOPPING: 0,
	Ingredient.Category.ICE_CREAM: 0,
	Ingredient.Category.WATER: 0,
	Ingredient.Category.SUGAR: 0
}:
	get:
		return ingredients
@export var steps: Array[Ingredient.Category]:
	get:
		return steps
@export var unlock_cost: int:
	get:
		return unlock_cost

func check_category(category: Ingredient.Category) -> bool:
	return category in steps

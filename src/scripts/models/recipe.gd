# recipe.gd
extends Resource
class_name Recipe

@export var name: String
@export_multiline var description: String
@export var ingredients: Dictionary = {
	Ingredient.Category.MILK: 0,
	Ingredient.Category.CREAM: 0,
	Ingredient.Category.GRAINS: 0,
	Ingredient.Category.SWEETNESS: 0,
	Ingredient.Category.TOPPING: 0,
	Ingredient.Category.ICE_CREAM: 0,
}
@export var steps: Array[Ingredient.Category]
@export var unlock_cost: int

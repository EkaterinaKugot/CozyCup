# ingredient.gd
extends Resource
class_name Ingredient

enum Category {
	MILK,       # Молочка
	CREAM, 		# Сливки	
	GRAINS,     # Зерна
	SWEETNESS,  # Сладость
	TOPPING,    # Посыпка
	ICE_CREAM	# Мороженное
}

@export var id: String 
@export var name: String
@export var category: Category
@export var purchase_cost: int  
@export var unlock_cost: int

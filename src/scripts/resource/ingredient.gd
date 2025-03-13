# ingredient.gd
extends Resource
class_name Ingredient

enum Category {
	MILK,       # Молочка
	CREAM, 		# Сливки	
	GRAINS,     # Зерна
	SYRUP,  	# Сироп
	TOPPING,    # Посыпка
	ICE_CREAM,	# Мороженное
	WATER,		# Вода
	SUGAR		# Сахар
}

@export var id: String:
	get:
		return id
@export var name: String:
	get:
		return name
@export var category: Category:
	get:
		return category
@export var is_basic: bool:
	get:
		return is_basic
@export var purchase_cost: int:
	get:
		return purchase_cost
@export var unlock_cost: int:
	get:
		return unlock_cost

func _equals(other: Ingredient) -> bool:
	if other == null or not (other is Ingredient):
		return false
	return self.id == other.id

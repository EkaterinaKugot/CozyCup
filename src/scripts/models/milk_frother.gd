class_name MilkFrother

var max_number_elements: int = 10:
	get:
		return max_number_elements
var number_milk: int = 0:
	get:
		return number_milk
	set(value):
		number_milk = min(value, max_number_elements)
var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value


var milk_is_ready: bool = false:
	get:
		return milk_is_ready
	set(value):
		milk_is_ready = value
var number_milk_shots: int = 0:
	get:
		return number_milk_shots
	set(value):
		if milk_is_ready == true:
			number_milk_shots = value
var ingredient_in_kettle: Ingredient:
	get:
		return ingredient_in_kettle
	set(value):
		ingredient_in_kettle = value

func add_number_milk(number: int) -> void:
	number_milk += number

func сooking_milk() -> void:
	milk_is_ready = true
	number_milk_shots = number_milk
	ingredient_in_kettle = ingredient
		
func use_elements() -> void:
	number_milk = 0
	ingredient = null
	
func clean_milk_kettle() -> void:
	milk_is_ready = false
	number_milk_shots = 0
	ingredient_in_kettle = null

func check_number_milk(ing: Ingredient, number: int) -> bool:
	return (ing == ingredient or ingredient == null) and number_milk + number <= max_number_elements

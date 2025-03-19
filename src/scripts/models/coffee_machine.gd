class_name CoffeeMachine

var max_number_elements: int = 10:
	get:
		return max_number_elements
var number_water: int = 0:
	get:
		return number_water
	set(value):
		number_water = min(value, max_number_elements)
var number_grains: int = 0:
	get:
		return number_grains
	set(value):
		number_grains = min(value, max_number_elements)	
var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value

var mini_game_is_start: bool = false:
	get:
		return mini_game_is_start
	set(value):
		mini_game_is_start = value

var coffee_is_ready: bool = false:
	get:
		return coffee_is_ready
	set(value):
		coffee_is_ready = value
var number_coffee_shots: int = 0:
	get:
		return number_coffee_shots
	set(value):
		if coffee_is_ready == true:
			number_coffee_shots = value
var ingredient_in_kettle: Ingredient:
	get:
		return ingredient_in_kettle
	set(value):
		ingredient_in_kettle = value

func fill_number_water() -> void:
	number_water = max_number_elements
	
func add_number_grains(number: int) -> void:
	number_grains += number

func cooking_coffee() -> void:
	coffee_is_ready = true
	number_coffee_shots = number_grains
	ingredient_in_kettle = ingredient
		
func use_elements() -> void:
	number_water -= number_grains
	number_grains = 0
	ingredient = null
	
func clean_coffee_kettle() -> void:
	coffee_is_ready = false
	number_coffee_shots = 0
	ingredient_in_kettle = null

func check_number_grains(ing: Ingredient, number: int) -> bool:
	return (ing == ingredient or ingredient == null) and number_grains + number <= max_number_elements

# progress.gd
extends Resource
class_name Progress

@export var number_start: int = 0:
	get:
		return number_start
	set(value):
		assert(value >= 0, "The value of number_start cannot be less than 0")
		number_start = value		
@export var day: int = 1:
	get:
		return day
	set(value):
		assert(value >= 1, "The value of day cannot be less than 1")
		day = value		

@export var option_duration_day: Dictionary = {10: [10, 20], 12: [9, 21], 14: [8, 22]}:
	get:
		return option_duration_day
@export var size_intervals: int = 10:
	get:
		return size_intervals
@export var duration_day: int = option_duration_day.keys()[0]:
	get:
		return duration_day
	set(value):
		assert(value in option_duration_day.keys(), "The value of duration_day cannot have such a value")
		duration_day = value

@export var rating: float = 5.0:
	get:
		return rating
	set(value):
		assert(value >= 1, "The value of rating cannot be less than 1")
		rating = value		
@export var number_grades: int = 1:
	get:
		return number_grades
	set(value):
		number_grades = value
const max_rating: int = 5

@export var money: int = 490:
	get:
		return money
	set(value):
		if value < 0:
			var error_message = "The value of money cannot be less than 0"
			push_error(error_message)  # Выводим ошибку в консоль
			return
		money = value	
@export var diamonds: int = 30:
	get:
		return diamonds
	set(value):
		if value < 0:
			if value < 0:
				var error_message = "The value of diamonds cannot be less than 0"
				push_error(error_message)  # Выводим ошибку в консоль
				return
		diamonds = value

@export var opened_ingredients: Dictionary = {}:
	get:
		return opened_ingredients
	set(value):
		assert(value.size() >= 0, "The size of opened_ingredients cannot be less than 0")
		opened_ingredients = value
@export var opened_recipes: Array[Recipe] = []:
	get:
		return opened_recipes
	set(value):
		assert(value.size() >= 0, "The size of opened_recipes cannot be less than 0")
		opened_recipes = value

@export var music: int = 7:
	get:
		return music
	set(value):
		assert(value >= 0 and value <= 10, "The value of music should be from 0 to 10")
		music = value	
@export var sounds: int = 7:
	get:
		return sounds
	set(value):
		assert(value >= 0 and value <= 10, "The value of sounds should be from 0 to 10")
		sounds = value
	
func add_number_start() -> void:
	number_start += 1
	
func add_day() -> void:
	day += 1

func change_duration_day_on_12() -> void:
	duration_day = option_duration_day.keys()[1]
	
func change_duration_day_on_14() -> void:
	duration_day = option_duration_day.keys()[2]
	
func change_rating(sum_grades: float, number_grades_per_day: int) -> void:
	assert(sum_grades >= 0, "The value of sum_grades should be larger or equal to zero")
	assert(number_grades_per_day >= 0, "The value of number_grades_per_day should be larger or equal to zero")
	rating = snappedf(( (rating * number_grades) + sum_grades) / (number_grades_per_day + number_grades), 0.1) 
	add_number_grades(number_grades_per_day)

func add_number_grades(number_grades_per_day: int) -> void:
	assert(number_grades_per_day >= 0, "The value of number_grades_per_day should be larger or equal to zero")
	number_grades += number_grades_per_day
	
func add_money(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	money += value
	
func sub_money(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	money -= value

func check_money(number: int) -> bool:
	return money - number >= 0
	
func add_diamonds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	diamonds += value
	
func sub_diamonds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	diamonds -= value
	
func add_new_opened_ingredients(ingredient: Ingredient, number: int = 5) -> void:
	assert(number >= 0, "The value of value cannot be less than 0")
	opened_ingredients[ingredient] = number

func add_number_ingredient(ingredient: Ingredient, number: int) -> void:
	assert(number >= 1, "The value of value cannot be less than 1")
	assert(ingredient in opened_ingredients.keys(), "There is no such value in opened_ingredients")
	opened_ingredients[ingredient] += number
	
func sub_number_ingredient(ingredient: Ingredient, number: int) -> void:
	assert(number >= 1, "The value of value cannot be less than 1")
	assert(ingredient in opened_ingredients.keys(), "There is no such value in opened_ingredients")
	opened_ingredients[ingredient] -= number

func check_number_ingredient(ingredient: Ingredient, number: int) -> bool:
	return opened_ingredients[ingredient] - number >= 0
	
func add_new_opened_recipes(recipe: Recipe) -> void:
	opened_recipes.append(recipe)

func add_music(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	music += value
	
func sub_music(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	music -= value
	
func add_sounds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	sounds += value
	
func sub_sounds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	sounds -= value
	
func select_ingredients_by_category(category: Ingredient.Category) -> Dictionary:
	var result = {}
	for ingredient in opened_ingredients.keys():
		if ingredient.category == category:
			result[ingredient] = opened_ingredients[ingredient]
	return result

func select_ingredients_by_id(id: String) -> Ingredient:
	for ingredient in opened_ingredients.keys():
		if ingredient.id == id:
			return ingredient
	return null

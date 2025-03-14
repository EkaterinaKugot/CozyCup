# Global.gd
extends Node

var progress: Progress = null
var recipes_list: RecipeList = null
var ingredients_list: IngredientList = null
var order_data: OrderData:
	get:
		return order_data
	set(value):
		order_data = value

var number_basic: int = 100

var progress_path: String = "user://progress.tres"
var recipes_path: String = "res://data/recipes_list.tres"
var ingredients_path: String = "res://data/ingredients_list.tres"
var order_data_path: String = "res://data/order_data.tres"

func _ready() -> void:
	recipes_list = load_data(recipes_path)
	ingredients_list = load_data(ingredients_path)
	load_progress()
	order_data = load_data(order_data_path)
	order_data.fill_name_recipe()

# Сохранение данных
func save_progress() -> void:
	var error_code = ResourceSaver.save(progress, progress_path)
	print("Сохранение завершено с кодом:", error_code)

# Загрузка данных прогресса
func load_progress() -> void:
	if ResourceLoader.exists(progress_path):
		#DirAccess.remove_absolute(progress_path)
		progress = ResourceLoader.load(progress_path)
	else:
		progress = Progress.new()
		add_basic_ingredients()
		add_basic_recipes()
		print("new progess")
		
	#progress.number_start = 0 
		
# Загрузка данных
func load_data(path: String):
	if ResourceLoader.exists(path):
		var data = ResourceLoader.load(path)
		return data
		
# Заполнение базовыми ингредиентами
func add_basic_ingredients() -> void:
	for ingredient in ingredients_list.ingredients:
		if ingredient.is_basic and not progress.opened_ingredients.keys().has(ingredient):
			progress.add_new_opened_ingredients(ingredient, number_basic)
			
# Заполнение базовыми рецептами
func add_basic_recipes() -> void:
	for recipe in recipes_list.recipes:
		if recipe.is_basic and not progress.opened_recipes.has(recipe):
			progress.add_new_opened_recipes(recipe)

# Global.gd
extends Node

var progress: Progress = null
var recipes_list: RecipeList = null
var ingredients_list: IngredientList = null

var number_basic: int = 100

var progress_path: String = "user://progress.tres"
var recipes_path: String = "res://data/recipes_list.tres"
var ingredients_path: String = "res://data/ingredients_list.tres"

func _ready() -> void:
	load_recipes()
	load_ingredients()
	load_progress()

# Сохранение данных
func save_progress() -> void:
	var error_code = ResourceSaver.save(progress, progress_path)
	print("Сохранение завершено с кодом:", error_code)

# Загрузка данных прогресса
func load_progress() -> void:
	if ResourceLoader.exists(progress_path):
		progress = ResourceLoader.load(progress_path)
	else:
		progress = Progress.new()
		add_basic_ingredients()
		add_basic_recipes()
		
	progress.number_start += 1
	#print(progress.number_start)
	#print(progress.opened_ingredients)
		
# Загрузка данных рецептов
func load_recipes() -> void:
	if ResourceLoader.exists(recipes_path):
		recipes_list = ResourceLoader.load(recipes_path)
	#print("Загружено рецептов:", recipes_list.recipes.size())

# Загрузка данных ингредиентов
func load_ingredients() -> void:
	if ResourceLoader.exists(ingredients_path):
		ingredients_list = ResourceLoader.load(ingredients_path)
	#print("Загружено ингредиентов:", ingredients_list.ingredients.size())
	
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

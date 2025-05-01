# Global.gd
extends Node

var progress: Progress = null
var settings: Settings = null
var recipes_list: RecipeList = null
var ingredients_list: IngredientList = null
var improvements_list: ImprovementsList = null
var order_data: OrderData:
	get:
		return order_data
	set(value):
		order_data = value

var progress_path: String = "user://progress.tres"
var settings_path: String = "user://settings.tres"

var recipes_path: String = "res://data/recipes_list.tres"
var ingredients_path: String = "res://data/ingredients_list.tres"
var order_data_path: String = "res://data/order_data.tres"
var improvements_path: String = "res://data/improvements_list.tres"

func _ready() -> void:
	recipes_list = load_data(recipes_path)
	ingredients_list = load_data(ingredients_path)
	improvements_list = load_data(improvements_path)
	
	load_progress()
	load_settings()
	
	order_data = load_data(order_data_path)
	order_data.fill_name_recipe()
	

# Сохранение данных
func save_progress() -> void:
	var error_code = ResourceSaver.save(progress, progress_path)
	
func save_settings() -> void:
	var error_code = ResourceSaver.save(settings, settings_path)

# Загрузка данных прогресса
func load_progress() -> void:
	if ResourceLoader.exists(progress_path):
		progress = ResourceLoader.load(progress_path, "", 4)
	else:
		progress = Progress.new()
		add_basic_ingredients()
		add_basic_recipes()
		progress.daily_tasks = DailyTasks.new()
		
# Загрузка настроек
func load_settings() -> void:
	if ResourceLoader.exists(settings_path):
		settings = ResourceLoader.load(settings_path, "", 4)
	else:
		settings = Settings.new()
		save_settings()
	
# Загрузка данных
func load_data(path: String):
	if ResourceLoader.exists(path):
		var data = ResourceLoader.load(path)
		return data
		
# Заполнение базовыми ингредиентами
func add_basic_ingredients() -> void:
	for ingredient in ingredients_list.ingredients:
		if ingredient.is_basic and not progress.opened_ingredients.keys().has(ingredient):
			progress.add_new_opened_ingredients(ingredient, progress.number_basic_ingredient)
			
# Заполнение базовыми рецептами
func add_basic_recipes() -> void:
	for recipe in recipes_list.recipes:
		if recipe.is_basic and not progress.opened_recipes.has(recipe):
			progress.add_new_opened_recipes(recipe)
			
func select_not_opened_ingredients() -> Array[Ingredient]:
	var result: Array[Ingredient]
	var opened_ingredients: Array = Array(progress.opened_ingredients.keys())
	for ingredient in ingredients_list.ingredients:
		if not opened_ingredients.has(ingredient):
			result.append(ingredient)
	return result
	
func select_not_opened_recipes() -> Array[Recipe]:
	var result: Array[Recipe]
	var opened_recipes: Array[Recipe] = progress.opened_recipes
	for recipe in recipes_list.recipes:
		if not opened_recipes.has(recipe):
			result.append(recipe)
	return result

func select_not_opened_improvements() -> Array[Improvement]:
	var result: Array[Improvement]
	var opened_improvements: Array[Improvement] = progress.opened_improvements
	for improvement in improvements_list.improvements:
		if not opened_improvements.has(improvement):
			result.append(improvement)
	return result
	
func select_improvement_by_id(id: String) -> Improvement:
	var result: Improvement
	for improvement in improvements_list.improvements:
		if improvement.id == id:
			result = improvement
			break
	return result
		

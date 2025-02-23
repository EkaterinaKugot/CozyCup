# Global.gd
extends Node

var progress_data: ProgressData = null
var recipes_data: RecipeList = null
var ingredients_data: IngredientList = null

var progress_path: String = "user://progress_save.tres"
var recipes_path: String = "res://data/recipes_list.tres"
var ingredients_path: String = "res://data/ingredients_list.tres"

func _ready() -> void:
	load_progress()
	load_recipes()
	load_ingredients()

# Сохранение данных
func save_progress() -> void:
	var error_code = ResourceSaver.save(progress_data, progress_path)
	print("Сохранение завершено с кодом:", error_code)

# Загрузка данных прогресса
func load_progress() -> void:
	if ResourceLoader.exists(progress_path):
		progress_data = ResourceLoader.load(progress_path)
	else:
		progress_data = ProgressData.new()
		
# Загрузка данных рецептов
func load_recipes() -> void:
	if ResourceLoader.exists(recipes_path):
		recipes_data = ResourceLoader.load(recipes_path)
		
func load_ingredients() -> void:
	if ResourceLoader.exists(ingredients_path):
		ingredients_data = ResourceLoader.load(ingredients_path)

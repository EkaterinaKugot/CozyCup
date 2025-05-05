extends GutTest

var Global = load("res://src/scripts/Autoload/Global.gd")
var global_instance = null

var test_progress_path = "res://tests/test_files/test_progress.tres"
var test_settings_path = "res://tests/test_files/test_settings.tres"
var test_recipes_path = "res://tests/test_files/test_recipes_list.tres"
var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"
var test_improvements_path = "res://tests/test_files/test_improvements_list.tres"
var test_order_data_path = "res://tests/test_files/test_order_data.tres"

func before_each():
	global_instance = Global.new()
	global_instance.progress_path = test_progress_path
	global_instance.settings_path = test_settings_path
	global_instance.recipes_path = test_recipes_path
	global_instance.ingredients_path = test_ingredients_path
	global_instance.improvements_path = test_improvements_path
	global_instance.order_data_path = test_order_data_path

func after_each():
	global_instance.free()

func test_load_data_exists():
	var result = global_instance.load_data(test_recipes_path)
	assert_not_null(result, "load_data должен возвращать ресурс, если файл существует")
	assert_true(result is RecipeList, "Загруженный ресурс должен быть типа RecipeList")

func test_load_data_not_exists():
	var invalid_path = "res://tests/test_files/invalid.tres"
	var result = global_instance.load_data(invalid_path)
	assert_null(result, "load_data должен возвращать null для несуществующего пути")

func test_load_progress_exists():
	global_instance.load_progress()
	assert_not_null(global_instance.progress, "Прогресс должен быть загружен из файла")
	assert_true(global_instance.progress is Progress, "Загруженный прогресс должен быть типа Progress")

func test_load_settings_exists():
	global_instance.load_settings()
	assert_not_null(global_instance.settings, "Настройки должны быть загружены из файла")
	assert_true(global_instance.settings is Settings, "Загруженные настройки должны быть типа Settings")

func test_add_basic_ingredients():
	global_instance.ingredients_list = global_instance.load_data(test_ingredients_path)
	global_instance.progress = Progress.new()
	
	global_instance.add_basic_ingredients()
	
	for ingredient in global_instance.ingredients_list.ingredients:
		if ingredient.is_basic:
			assert_true(global_instance.progress.opened_ingredients.has(ingredient), "Базовый ингредиент должен быть добавлен")

func test_add_basic_recipes():
	global_instance.recipes_list = global_instance.load_data(test_recipes_path)
	global_instance.progress = Progress.new()
	
	global_instance.add_basic_recipes()
	
	for recipe in global_instance.recipes_list.recipes:
		if recipe.is_basic:
			assert_true(global_instance.progress.opened_recipes.has(recipe), "Базовый рецепт должен быть добавлен")

func test_save_progress():
	global_instance.progress = Progress.new()
	global_instance.save_progress()
	assert_true(FileAccess.file_exists(test_progress_path), "Файл прогресса должен быть сохранен")

func test_save_settings():
	global_instance.settings = Settings.new()
	global_instance.save_settings()
	assert_true(FileAccess.file_exists(test_settings_path), "Файл настроек должен быть сохранен")

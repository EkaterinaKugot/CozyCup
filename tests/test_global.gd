extends GutTest

# Пути к тестовым файлам
var test_progress_path: String = "user://test_progress.tres"
var test_recipes_path: String = "res://src/tests/test_files/test_recipes_list.tres"
var test_ingredients_path: String = "res://src/tests/test_files/test_ingredients_list.tres"

func before_each():
	
	# Подменяем пути на тестовые
	Global.progress_path = test_progress_path
	Global.recipes_path = test_recipes_path
	Global.ingredients_path = test_ingredients_path
	
	# Очищаем тестовые файлы перед каждым тестом
	if FileAccess.file_exists(test_progress_path):
		DirAccess.remove_absolute(test_progress_path)
	if FileAccess.file_exists(test_recipes_path):
		DirAccess.remove_absolute(test_recipes_path)
	if FileAccess.file_exists(test_ingredients_path):
		DirAccess.remove_absolute(test_ingredients_path)

func after_each():
	# Очищаем тестовые файлы после каждого теста
	if FileAccess.file_exists(test_progress_path):
		DirAccess.remove_absolute(test_progress_path)
	if FileAccess.file_exists(test_recipes_path):
		DirAccess.remove_absolute(test_recipes_path)
	if FileAccess.file_exists(test_ingredients_path):
		DirAccess.remove_absolute(test_ingredients_path)

### Тесты для загрузки данных
func test_load_progress():
	# Проверка загрузки прогресса, если файл существует
	var fake_progress = Progress.new()
	fake_progress.number_start = 5
	ResourceSaver.save(fake_progress, test_progress_path)
	Global.load_progress()
	assert_eq(Global.progress.number_start, 6, "number_start должен увеличиться на 1")

	# Проверка загрузки прогресса, если файл не существует
	Global.progress = null
	DirAccess.remove_absolute(test_progress_path)
	Global.load_progress()
	assert_not_null(Global.progress, "progress должен быть создан, если файл не существует")
	assert_eq(Global.progress.number_start, 1, "number_start должен быть 1 для нового прогресса")

func test_load_recipes():
	# Проверка загрузки рецептов, если файл существует
	var fake_recipes_list = RecipeList.new()
	
	var recipes_array: Array[Recipe] = [Recipe.new(), Recipe.new()]
	fake_recipes_list.recipes = recipes_array
	
	ResourceSaver.save(fake_recipes_list, test_recipes_path)
	Global.load_recipes()
	assert_eq(Global.recipes_list.recipes.size(), 2, "Должно быть загружено 2 рецепта")

	# Проверка загрузки рецептов, если файл не существует
	Global.recipes_list = null
	DirAccess.remove_absolute(test_recipes_path)
	Global.load_recipes()
	assert_null(Global.recipes_list, "recipes_list должен быть null, если файл не существует")

func test_load_ingredients():
	# Проверка загрузки ингредиентов, если файл существует
	var fake_ingredients_list = IngredientList.new()
	
	var ingredients_array: Array[Ingredient] = [Ingredient.new(), Ingredient.new()]
	fake_ingredients_list.ingredients = ingredients_array
	
	ResourceSaver.save(fake_ingredients_list, test_ingredients_path)
	Global.load_ingredients()
	assert_eq(Global.ingredients_list.ingredients.size(), 2, "Должно быть загружено 2 ингредиента")

	# Проверка загрузки ингредиентов, если файл не существует
	Global.ingredients_list = null
	DirAccess.remove_absolute(test_ingredients_path)
	Global.load_ingredients()
	assert_null(Global.ingredients_list, "ingredients_list должен быть null, если файл не существует")

### Тесты для добавления базовых данных
func test_add_basic_ingredients():
	# Создаем базовые ингредиенты
	var ingredient1 = Ingredient.new()
	ingredient1.is_basic = true
	var ingredient2 = Ingredient.new()
	ingredient2.is_basic = false
	Global.ingredients_list = IngredientList.new()
	Global.ingredients_list.ingredients = [ingredient1, ingredient2]

	# Проверка добавления базовых ингредиентов
	Global.add_basic_ingredients()
	assert_gt(Global.progress.opened_ingredients.size(), 0, "Должен быть добавлен 1 базовый ингредиент")
	assert_true(Global.progress.opened_ingredients.has(ingredient1), "Базовый ингредиент должен быть добавлен")

func test_add_basic_recipes():
	# Создаем базовые рецепты
	var recipe1 = Recipe.new()
	recipe1.is_basic = true
	var recipe2 = Recipe.new()
	recipe2.is_basic = false
	Global.recipes_list = RecipeList.new()
	Global.recipes_list.recipes = [recipe1, recipe2]

	# Проверка добавления базовых рецептов
	Global.add_basic_recipes()
	assert_gt(Global.progress.opened_recipes.size(), 0, "Должен быть добавлен 1 базовый рецепт")
	assert_true(Global.progress.opened_recipes.has(recipe1), "Базовый рецепт должен быть добавлен")

### Тесты для сохранения данных
func test_save_progress():
	# Проверка сохранения прогресса
	Global.progress = Progress.new()
	Global.progress.number_start = 10
	Global.save_progress()
	var saved_progress = ResourceLoader.load(test_progress_path)
	assert_eq(saved_progress.number_start, 10, "Прогресс должен быть сохранен корректно")

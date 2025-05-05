extends GutTest

var order_instance = null

var test_progress_path = "res://tests/test_files/test_progress.tres"
var test_recipes_path = "res://tests/test_files/test_recipes_list.tres"
var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"
var test_order_data_path = "res://tests/test_files/test_order_data.tres"

func before_each():
	order_instance = Order.new()
	
	# Настраиваем Global с тестовыми путями
	Global.progress_path = test_progress_path
	Global.recipes_path = test_recipes_path
	Global.ingredients_path = test_ingredients_path
	Global.order_data_path = test_order_data_path
	
	# Загружаем ресурсы
	Global.load_progress()
	Global.recipes_list = Global.load_data(test_recipes_path)
	Global.ingredients_list = Global.load_data(test_ingredients_path)
	Global.order_data = Global.load_data(test_order_data_path)
	Global.add_basic_recipes()
	Global.add_basic_ingredients()
	Global.order_data.fill_name_recipe()
	
	assert_not_null(Global.progress, "Прогресс должен быть загружен")
	assert_not_null(Global.recipes_list, "Список рецептов должен быть загружен")
	assert_not_null(Global.ingredients_list, "Список ингредиентов должен быть загружен")
	assert_not_null(Global.order_data, "OrderData должен быть загружен")

func after_each():
	order_instance = null
	Global.progress = null
	Global.recipes_list = null
	Global.ingredients_list = null
	Global.order_data = null

func test_properties():
	# Проверка начальных значений
	assert_eq(order_instance.recipe, null, "recipe должно быть null изначально")
	assert_eq(order_instance.step_ingredient, {}, "step_ingredient должно быть пустым изначально")
	assert_eq(order_instance.text, "", "text должно быть пустым изначально")
	assert_eq(order_instance.price, 0, "price должно быть 0 изначально")
	assert_false(order_instance.time_is_exceeded, "time_is_exceeded должно быть false изначально")
	assert_eq(order_instance.lead_time, 40.0, "lead_time должно быть 40.0")

func test_add_ingredient():
	var ingredient = Global.ingredients_list.ingredients[0] # Берем первый ингредиент из списка
	order_instance.add_ingredient(ingredient, 2)
	assert_true(order_instance.step_ingredient.has(ingredient), "Ингредиент должен быть добавлен")
	assert_eq(order_instance.step_ingredient[ingredient], 2, "Количество ингредиента должно быть 2")

func test_calculate_price():
	var ingredient1 = Global.ingredients_list.ingredients[0]
	var ingredient2 = Global.ingredients_list.ingredients[1] if Global.ingredients_list.ingredients.size() > 1 else ingredient1
	ingredient1.purchase_cost = 10
	ingredient2.purchase_cost = 5
	order_instance.step_ingredient = {ingredient1: 2, ingredient2: 3}
	
	order_instance.calculate_price()
	assert_eq(order_instance.price, 35, "price должен быть 10*2 + 5*3 = 35")

func test_add_words():
	order_instance.add_words("привет")
	assert_eq(order_instance.text, " привет", "add_words должен добавить слово с пробелом")
	
	order_instance.text = ""
	order_instance.add_words("мир", false)
	assert_eq(order_instance.text, "мир", "add_words без пробела должен добавить слово без пробела")

func test_add_introductory_words():
	var recipe = Global.recipes_list.recipes[0]
	if recipe == null:
		fail_test("Рецепт 'cappuccino' не найден в test_recipes_list.tres")
		return
	
	order_instance.recipe = recipe
	order_instance.add_introductory_words(Global.order_data)
	assert_true(order_instance.text.contains("капучино"), "add_introductory_words должен включать название рецепта")

func test_select_random_ingredient():
	var ingredient = order_instance.select_random_ingredient(Ingredient.Category.GRAINS)
	if Global.progress.opened_ingredients.is_empty():
		assert_null(ingredient, "select_random_ingredient должен вернуть null, если нет доступных ингредиентов")
	else:
		assert_not_null(ingredient, "select_random_ingredient должен вернуть ингредиент")
		assert_eq(ingredient.category, Ingredient.Category.GRAINS, "Ингредиент должен быть из категории GRAINS")

func test_add_ingredient_by_category():
	var recipe = Global.recipes_list.recipes[0]
	if recipe == null:
		fail_test("Рецепт 'cappuccino' не найден в test_recipes_list.tres")
		return
	
	recipe.ingredients = {Ingredient.Category.GRAINS: 2}
	order_instance.recipe = recipe
	
	var result = order_instance.add_ingredient_by_category(Ingredient.Category.GRAINS)
	if Global.progress.opened_ingredients.is_empty():
		assert_null(result, "add_ingredient_by_category должен вернуть null, если нет ингредиентов")
	else:
		assert_not_null(result, "add_ingredient_by_category должен вернуть добавленный ингредиент")
		assert_true(order_instance.step_ingredient.has(result), "Ингредиент должен быть добавлен")
		assert_eq(order_instance.step_ingredient[result], 2, "Количество ингредиента должно быть 2")

func test_make_order_cappuccino():
	var recipe = Global.recipes_list.recipes[0]
	if recipe == null:
		fail_test("Рецепт 'cappuccino' не найден в test_recipes_list.tres")
		return
	
	# Устанавливаем прогресс с доступным рецептом
	Global.progress.opened_recipes = [recipe]
	
	order_instance.make_order()
	assert_eq(order_instance.recipe, recipe, "recipe должно быть cappuccino")
	assert_true(order_instance.text.contains("капучино"), "text должен содержать название рецепта")
	assert_false(order_instance.step_ingredient.is_empty(), "Ингредиенты должны быть добавлены")

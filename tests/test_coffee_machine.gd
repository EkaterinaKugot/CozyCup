extends GutTest

var coffee_machine_instance = null

var test_progress_path = "res://tests/test_files/test_progress.tres"
var test_improvements_path = "res://tests/test_files/test_improvements_list.tres"
var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"

func before_each():

	# Настраиваем Global с тестовыми путями
	Global.progress_path = test_progress_path
	Global.improvements_path = test_improvements_path
	Global.ingredients_path = test_ingredients_path
	
	# Загружаем ресурсы
	Global.load_progress()
	Global.improvements_list = Global.load_data(test_improvements_path)
	Global.ingredients_list = Global.load_data(test_ingredients_path)
	
	coffee_machine_instance = CoffeeMachine.new()
	
	assert_not_null(Global.progress, "Прогресс должен быть загружен")
	assert_not_null(Global.improvements_list, "Список улучшений должен быть загружен")
	assert_not_null(Global.ingredients_list, "Список ингредиентов должен быть загружен")

func after_each():
	coffee_machine_instance = null
	Global.progress = null
	Global.improvements_list = null
	Global.ingredients_list = null

func test_properties():
	# Проверка начальных значений
	assert_eq(coffee_machine_instance.max_number_elements, 5, "max_number_elements должно быть 5")
	assert_eq(coffee_machine_instance.number_water, 0, "number_water должно быть 0 изначально")
	assert_eq(coffee_machine_instance.number_grains, 0, "number_grains должно быть 0 изначально")
	assert_null(coffee_machine_instance.ingredient, "ingredient должно быть null изначально")
	assert_false(coffee_machine_instance.mini_game_is_start, "mini_game_is_start должно быть false изначально")
	assert_false(coffee_machine_instance.coffee_is_ready, "coffee_is_ready должно быть false изначально")
	assert_eq(coffee_machine_instance.number_coffee_shots, 0, "number_coffee_shots должно быть 0 изначально")
	assert_null(coffee_machine_instance.ingredient_in_kettle, "ingredient_in_kettle должно быть null изначально")
	assert_not_null(coffee_machine_instance.water_tank_full, "water_tank_full должно быть установлено")

func test_init_with_water_tank_full():
	var improvement = Global.improvements_list.improvements[0]
	if improvement == null:
		fail_test("Улучшение 'water_tank_full' не найдено в test_improvements_list.tres")
		return
	
	Global.progress.opened_improvements = [improvement]
	coffee_machine_instance = CoffeeMachine.new()
	assert_eq(coffee_machine_instance.number_water, 5, "number_water должно быть max_number_elements при наличии улучшения")

func test_fill_number_water():
	coffee_machine_instance.fill_number_water()
	assert_eq(coffee_machine_instance.number_water, 5, "number_water должно быть max_number_elements после fill_number_water")

func test_add_number_grains():
	coffee_machine_instance.add_number_grains(3)
	assert_eq(coffee_machine_instance.number_grains, 3, "number_grains должно увеличиться на 3")
	coffee_machine_instance.add_number_grains(4)
	assert_eq(coffee_machine_instance.number_grains, 5, "number_grains должно увеличиться равняться максимальному числу 5")

func test_cooking_coffee():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_machine_instance.ingredient = ingredient
	coffee_machine_instance.number_grains = 2
	coffee_machine_instance.cooking_coffee()
	assert_true(coffee_machine_instance.coffee_is_ready, "coffee_is_ready должно быть true после cooking_coffee")
	assert_eq(coffee_machine_instance.number_coffee_shots, 2, "number_coffee_shots должно равняться number_grains")
	assert_eq(coffee_machine_instance.ingredient_in_kettle, ingredient, "ingredient_in_kettle должно равняться ingredient")

func test_use_elements_without_improvement():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_machine_instance.number_water = 4
	coffee_machine_instance.number_grains = 2
	coffee_machine_instance.ingredient = ingredient
	Global.progress.opened_improvements = []
	coffee_machine_instance.use_elements()
	assert_eq(coffee_machine_instance.number_water, 2, "number_water должно уменьшиться на number_grains")
	assert_eq(coffee_machine_instance.number_grains, 0, "number_grains должно быть сброшено")
	assert_null(coffee_machine_instance.ingredient, "ingredient должно быть null")

func test_use_elements_with_improvement():
	var improvement = Global.improvements_list.improvements[0]
	if improvement == null:
		fail_test("Улучшение 'water_tank_full' не найдено в test_improvements_list.tres")
		return
	
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_machine_instance.number_water = 4
	coffee_machine_instance.number_grains = 2
	coffee_machine_instance.ingredient = ingredient
	Global.progress.opened_improvements = [improvement]
	coffee_machine_instance.use_elements()
	assert_eq(coffee_machine_instance.number_water, 5, "number_water должно быть max_number_elements при наличии улучшения")
	assert_eq(coffee_machine_instance.number_grains, 0, "number_grains должно быть сброшено")
	assert_null(coffee_machine_instance.ingredient, "ingredient должно быть null")

func test_clean_coffee_kettle():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_machine_instance.coffee_is_ready = true
	coffee_machine_instance.number_coffee_shots = 3
	coffee_machine_instance.ingredient_in_kettle = ingredient
	coffee_machine_instance.clean_coffee_kettle()

	assert_eq(coffee_machine_instance.coffee_is_ready, false, "coffee_is_ready должно быть false после clean_coffee_kettle")
	assert_eq(coffee_machine_instance.number_coffee_shots, 0, "number_coffee_shots должно быть 0")
	assert_null(coffee_machine_instance.ingredient_in_kettle, "ingredient_in_kettle должно быть null")

func test_check_number_grains():
	var ingredient1 = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	var ingredient2 = Global.ingredients_list.ingredients[1] if Global.ingredients_list.ingredients.size() > 1 else null
	if ingredient1 == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_machine_instance.ingredient = ingredient1
	coffee_machine_instance.number_grains = 2
	assert_true(coffee_machine_instance.check_number_grains(ingredient1, 2), "check_number_grains должно вернуть true для совпадающего ингредиента и допустимого количества")
	assert_false(coffee_machine_instance.check_number_grains(ingredient1, 4), "check_number_grains должно вернуть false, если превышает max_number_elements")
	if ingredient2 != null:
		assert_false(coffee_machine_instance.check_number_grains(ingredient2, 1), "check_number_grains должно вернуть false для другого ингредиента")
	
	coffee_machine_instance.ingredient = null
	assert_true(coffee_machine_instance.check_number_grains(ingredient1, 3), "check_number_grains должно вернуть true, если ingredient == null")

extends GutTest

var milk_frother_instance = null

var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"

func before_each():

	# Настраиваем Global с тестовым путем
	Global.ingredients_path = test_ingredients_path
	
	# Загружаем ингредиенты
	Global.ingredients_list = Global.load_data(test_ingredients_path)
	
	milk_frother_instance = MilkFrother.new()
	
	assert_not_null(Global.ingredients_list, "Список ингредиентов должен быть загружен")

func after_each():
	milk_frother_instance = null
	Global.ingredients_list = null

func test_properties():
	# Проверка начальных значений
	assert_eq(milk_frother_instance.max_number_elements, 10, "max_number_elements должно быть 10")
	assert_eq(milk_frother_instance.number_milk, 0, "number_milk должно быть 0 изначально")
	assert_null(milk_frother_instance.ingredient, "ingredient должно быть null изначально")
	assert_false(milk_frother_instance.milk_is_ready, "milk_is_ready должно быть false изначально")
	assert_eq(milk_frother_instance.number_milk_shots, 0, "number_milk_shots должно быть 0 изначально")
	assert_null(milk_frother_instance.ingredient_in_kettle, "ingredient_in_kettle должно быть null изначально")

func test_add_number_milk():
	milk_frother_instance.add_number_milk(3)
	assert_eq(milk_frother_instance.number_milk, 3, "number_milk должно увеличиться на 3")
	milk_frother_instance.add_number_milk(4)
	assert_eq(milk_frother_instance.number_milk, 7, "number_milk должно увеличиться еще на 4")

func test_cooking_milk():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	milk_frother_instance.ingredient = ingredient
	milk_frother_instance.number_milk = 5
	milk_frother_instance.cooking_milk()
	assert_true(milk_frother_instance.milk_is_ready, "milk_is_ready должно быть true после cooking_milk")
	assert_eq(milk_frother_instance.number_milk_shots, 5, "number_milk_shots должно равняться number_milk")
	assert_eq(milk_frother_instance.ingredient_in_kettle, ingredient, "ingredient_in_kettle должно равняться ingredient")

func test_use_elements():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	milk_frother_instance.number_milk = 5
	milk_frother_instance.ingredient = ingredient
	milk_frother_instance.use_elements()
	assert_eq(milk_frother_instance.number_milk, 0, "number_milk должно быть сброшено")
	assert_null(milk_frother_instance.ingredient, "ingredient должно быть null")

func test_clean_milk_kettle():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	milk_frother_instance.milk_is_ready = true
	milk_frother_instance.number_milk_shots = 3
	milk_frother_instance.ingredient_in_kettle = ingredient
	milk_frother_instance.clean_milk_kettle()
	assert_false(milk_frother_instance.milk_is_ready, "milk_is_ready должно быть false после clean_milk_kettle")
	assert_eq(milk_frother_instance.number_milk_shots, 0, "number_milk_shots должно быть 0")
	assert_null(milk_frother_instance.ingredient_in_kettle, "ingredient_in_kettle должно быть null")

func test_check_number_milk():
	var ingredient1 = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	var ingredient2 = Global.ingredients_list.ingredients[1] if Global.ingredients_list.ingredients.size() > 1 else null
	if ingredient1 == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	milk_frother_instance.ingredient = ingredient1
	milk_frother_instance.number_milk = 4
	assert_true(milk_frother_instance.check_number_milk(ingredient1, 5), "check_number_milk должно вернуть true для совпадающего ингредиента и допустимого количества")
	assert_false(milk_frother_instance.check_number_milk(ingredient1, 7), "check_number_milk должно вернуть false, если превышает max_number_elements")
	if ingredient2 != null:
		assert_false(milk_frother_instance.check_number_milk(ingredient2, 1), "check_number_milk должно вернуть false для другого ингредиента")
	
	milk_frother_instance.ingredient = null
	assert_true(milk_frother_instance.check_number_milk(ingredient1, 6), "check_number_milk должно вернуть true, если ingredient == null")

extends GutTest

var coffee_cup_instance = null

var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"

func before_each():
	coffee_cup_instance = CoffeeCup.new()
	
	# Настраиваем Global с тестовым путем
	Global.ingredients_path = test_ingredients_path
	
	# Загружаем ингредиенты
	Global.ingredients_list = Global.load_data(test_ingredients_path)
	
	assert_not_null(Global.ingredients_list, "Список ингредиентов должен быть загружен")

func after_each():
	coffee_cup_instance = null
	Global.ingredients_list = null

func test_properties():
	# Проверка начальных значений
	assert_eq(coffee_cup_instance.added_ingredients, [], "added_ingredients должно быть пустым массивом изначально")
	assert_eq(coffee_cup_instance.added_topping, {}, "added_topping должно быть пустым словарем изначально")
	assert_null(coffee_cup_instance.current_topping, "current_topping должно быть null изначально")
	assert_false(coffee_cup_instance.is_chosen, "is_chosen должно быть false изначально")

func test_add_ingredient():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_cup_instance.add_ingredient(ingredient, 2)
	assert_eq(coffee_cup_instance.added_ingredients.size(), 1, "Должен быть добавлен один ингредиент")
	assert_eq(coffee_cup_instance.added_ingredients[0][ingredient], 2, "Количество ингредиента должно быть 2")
	
	# Добавляем тот же ингредиент
	coffee_cup_instance.add_ingredient(ingredient, 3)
	assert_eq(coffee_cup_instance.added_ingredients.size(), 1, "Не должен добавляться новый словарь для того же ингредиента")
	assert_eq(coffee_cup_instance.added_ingredients[0][ingredient], 5, "Количество ингредиента должно увеличиться до 5")

func test_add_different_ingredient():
	var ingredient1 = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	var ingredient2 = Global.ingredients_list.ingredients[1] if Global.ingredients_list.ingredients.size() > 1 else null
	if ingredient1 == null or ingredient2 == null:
		fail_test("Недостаточно ингредиентов в test_ingredients_list.tres")
		return
	
	coffee_cup_instance.add_ingredient(ingredient1, 2)
	coffee_cup_instance.add_ingredient(ingredient2, 1)
	assert_eq(coffee_cup_instance.added_ingredients.size(), 2, "Должны быть добавлены два разных ингредиента")
	assert_eq(coffee_cup_instance.added_ingredients[0][ingredient1], 2, "Количество первого ингредиента должно быть 2")
	assert_eq(coffee_cup_instance.added_ingredients[1][ingredient2], 1, "Количество второго ингредиента должно быть 1")

func test_add_topping():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	var position1 = Vector2(10, 20)
	var position2 = Vector2(30, 40)
	
	coffee_cup_instance.add_topping(ingredient, position1)
	assert_true(coffee_cup_instance.added_topping.has(ingredient), "Ингредиент должен быть добавлен в added_topping")
	assert_eq(coffee_cup_instance.added_topping[ingredient], [position1], "Позиция должна быть добавлена")
	
	coffee_cup_instance.add_topping(ingredient, position2)
	assert_eq(coffee_cup_instance.added_topping[ingredient], [position1, position2], "Вторая позиция должна быть добавлена к тому же ингредиенту")

func test_clean_coffee_cup():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	coffee_cup_instance.add_ingredient(ingredient, 2)
	coffee_cup_instance.add_topping(ingredient, Vector2(10, 20))
	coffee_cup_instance.current_topping = ingredient
	
	coffee_cup_instance.clean_coffee_cup()
	assert_eq(coffee_cup_instance.added_ingredients, [], "added_ingredients должно быть очищено")
	assert_eq(coffee_cup_instance.added_topping, {}, "added_topping должно быть очищено")
	assert_null(coffee_cup_instance.current_topping, "current_topping должно быть null")
	assert_false(coffee_cup_instance.is_chosen, "is_chosen должно остаться false")

func test_check_has_category():
	var ingredient = Global.ingredients_list.ingredients[0] if Global.ingredients_list.ingredients.size() > 0 else null
	if ingredient == null:
		fail_test("Ингредиенты не найдены в test_ingredients_list.tres")
		return
	
	ingredient.category = Ingredient.Category.GRAINS
	coffee_cup_instance.add_ingredient(ingredient, 1)
	
	assert_true(coffee_cup_instance.check_has_category(Ingredient.Category.GRAINS), "check_has_category должно вернуть true для добавленной категории")
	assert_false(coffee_cup_instance.check_has_category(Ingredient.Category.MILK), "check_has_category должно вернуть false для отсутствующей категории")

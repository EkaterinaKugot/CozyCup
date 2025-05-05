extends GutTest

var progress_instance = null

func before_each():
	progress_instance = Progress.new()
	# Инициализируем daily_tasks
	progress_instance.daily_tasks = DailyTasks.new()

func after_each():
	progress_instance = null

func test_number_start():
	progress_instance.number_start = 5
	assert_eq(progress_instance.number_start, 5, "number_start должен быть равен 5")
	progress_instance.add_number_start()
	assert_eq(progress_instance.number_start, 6, "add_number_start должен увеличить number_start на 1")

func test_day():
	progress_instance.day = 3
	assert_eq(progress_instance.day, 3, "day должен быть равен 3")
	progress_instance.add_day()
	assert_eq(progress_instance.day, 4, "add_day должен увеличить day на 1")

func test_duration_day():
	assert_eq(progress_instance.duration_day, 5, "duration_day должен быть равен 5")


func test_rating():
	progress_instance.rating = 4.5
	assert_eq(progress_instance.rating, 4.5, "rating должен быть равен 4.5")
	progress_instance.change_rating(8.0, 2)
	assert_almost_eq(progress_instance.rating, 4.3, 0.1, "rating должен быть примерно 4.3 после изменения")
	assert_eq(progress_instance.number_grades, 3, "number_grades должен увеличиться на 2")

func test_money():
	progress_instance.money = 200
	assert_eq(progress_instance.money, 200, "money должен быть равен 200")
	progress_instance.add_money(50)
	assert_eq(progress_instance.money, 250, "add_money должен увеличить money на 50")
	progress_instance.sub_money(100)
	assert_eq(progress_instance.money, 150, "sub_money должен уменьшить money на 100")
	assert_true(progress_instance.check_money(50), "check_money должен вернуть true для 50")
	assert_false(progress_instance.check_money(200), "check_money должен вернуть false для 200")

func test_diamonds():
	progress_instance.diamonds = 10
	assert_eq(progress_instance.diamonds, 10, "diamonds должен быть равен 10")
	progress_instance.add_diamonds(5)
	assert_eq(progress_instance.diamonds, 15, "add_diamonds должен увеличить diamonds на 5")
	progress_instance.sub_diamonds(3)
	assert_eq(progress_instance.diamonds, 12, "sub_diamonds должен уменьшить diamonds на 3")
	assert_true(progress_instance.check_diamonds(10), "check_diamonds должен вернуть true для 10")
	assert_false(progress_instance.check_diamonds(20), "check_diamonds должен вернуть false для 20")

func test_opened_ingredients():
	var ingredient = Ingredient.new()
	ingredient.id = "test_ingredient"
	ingredient.category = Ingredient.Category.GRAINS
	
	progress_instance.add_new_opened_ingredients(ingredient, 10)
	assert_true(progress_instance.opened_ingredients.has(ingredient), "Ингредиент должен быть добавлен")
	assert_eq(progress_instance.opened_ingredients[ingredient], 10, "Количество ингредиента должно быть 10")
	
	progress_instance.add_number_ingredient(ingredient, 5)
	assert_eq(progress_instance.opened_ingredients[ingredient], 15, "add_number_ingredient должен увеличить количество на 5")
	
	progress_instance.sub_number_ingredient(ingredient, 3)
	assert_eq(progress_instance.opened_ingredients[ingredient], 12, "sub_number_ingredient должен уменьшить количество на 3")
	
	assert_true(progress_instance.check_number_ingredient(ingredient, 10), "check_number_ingredient должен вернуть true для 10")
	assert_false(progress_instance.check_number_ingredient(ingredient, 20), "check_number_ingredient должен вернуть false для 20")

func test_opened_recipes():
	var recipe = Recipe.new()
	recipe.id = "test_recipe"
	
	progress_instance.add_new_opened_recipes(recipe)
	assert_true(progress_instance.opened_recipes.has(recipe), "Рецепт должен быть добавлен")

func test_opened_improvements():
	var improvement = Improvement.new()
	improvement.id = "test_improvement"
	
	progress_instance.add_new_improvement(improvement)
	assert_true(progress_instance.opened_improvements.has(improvement), "Улучшение должно быть добавлено")
	assert_true(progress_instance.has_improvement(improvement), "has_improvement должен вернуть true")
	
	var selected_improvement = progress_instance.select_improvement_by_id("test_improvement")
	assert_eq(selected_improvement, improvement, "select_improvement_by_id должен вернуть правильное улучшение")

func test_select_ingredients_by_category():
	var ingredient = Ingredient.new()
	ingredient.id = "test_ingredient"
	ingredient.category = Ingredient.Category.MILK
	
	progress_instance.add_new_opened_ingredients(ingredient, 5)
	
	var result = progress_instance.select_ingredients_by_category(Ingredient.Category.MILK)
	assert_true(result.has(ingredient), "Ингредиент с категорией BASE должен быть в результате")
	assert_eq(result[ingredient], 5, "Количество ингредиента должно быть 5")

func test_select_ingredients_by_id():
	var ingredient = Ingredient.new()
	ingredient.id = "test_ingredient"
	
	progress_instance.add_new_opened_ingredients(ingredient, 5)
	
	var selected_ingredient = progress_instance.select_ingredients_by_id("test_ingredient")
	assert_eq(selected_ingredient, ingredient, "select_ingredients_by_id должен вернуть правильный ингредиент")
	
	var invalid_ingredient = progress_instance.select_ingredients_by_id("invalid_id")
	assert_eq(invalid_ingredient, null, "select_ingredients_by_id должен вернуть null для несуществующего ID")

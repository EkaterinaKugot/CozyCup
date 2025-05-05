extends GutTest


var GameDay = load("res://src/scripts/Autoload/GameDay.gd")
var game_day_instance = null

# Пути к тестовым файлам
var test_progress_path = "res://tests/test_files/test_progress.tres"
var test_settings_path = "res://tests/test_files/test_settings.tres"
var test_recipes_path = "res://tests/test_files/test_recipes_list.tres"
var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"
var test_improvements_path = "res://tests/test_files/test_improvements_list.tres"
var test_order_data_path = "res://tests/test_files/test_order_data.tres"

# Исходные пути Global для восстановления
var original_paths = {
	"progress_path": Global.progress_path,
	"settings_path": Global.settings_path,
	"recipes_path": Global.recipes_path,
	"ingredients_path": Global.ingredients_path,
	"improvements_path": Global.improvements_path,
	"order_data_path": Global.order_data_path
}

func before_each():
	# Создаем экземпляр GameDay
	game_day_instance = GameDay.new()
	
	# Настраиваем пути к тестовым файлам в Global
	Global.progress_path = test_progress_path
	Global.settings_path = test_settings_path
	Global.recipes_path = test_recipes_path
	Global.ingredients_path = test_ingredients_path
	Global.improvements_path = test_improvements_path
	Global.order_data_path = test_order_data_path
	
	# Проверяем существование тестовых файлов и загружаем данные
	if ResourceLoader.exists(test_progress_path):
		Global.load_progress()
	else:
		Global.progress = Progress.new()
	if ResourceLoader.exists(test_settings_path):
		Global.load_settings()
	else:
		Global.settings = Settings.new()
	if ResourceLoader.exists(test_recipes_path):
		Global.recipes_list = Global.load_data(test_recipes_path)
	else:
		Global.recipes_list = RecipeList.new()
	if ResourceLoader.exists(test_ingredients_path):
		Global.ingredients_list = Global.load_data(test_ingredients_path)
	else:
		Global.ingredients_list = IngredientList.new()
	if ResourceLoader.exists(test_improvements_path):
		Global.improvements_list = Global.load_data(test_improvements_path)
	else:
		Global.improvements_list = ImprovementsList.new()
	if ResourceLoader.exists(test_order_data_path):
		Global.order_data = Global.load_data(test_order_data_path)
	else:
		Global.order_data = OrderData.new()
	Global.add_basic_ingredients()
	Global.add_basic_recipes()
	Global.order_data.fill_name_recipe()
	

func after_each():
	# Очищаем экземпляр
	game_day_instance.free()
	
	# Восстанавливаем исходные пути Global
	Global.progress_path = original_paths.progress_path
	Global.settings_path = original_paths.settings_path
	Global.recipes_path = original_paths.recipes_path
	Global.ingredients_path = original_paths.ingredients_path
	Global.improvements_path = original_paths.improvements_path
	Global.order_data_path = original_paths.order_data_path

func test_start_menu_stage():
	game_day_instance.start_menu_stage()
	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.MENU, "Текущая стадия должна быть MENU")
	assert_null(game_day_instance.statistic, "Статистика должна быть null")

func test_start_purchase_stage():
	game_day_instance.start_purchase_stage()
	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.PURCHASE, "Текущая стадия должна быть PURCHASE")
	assert_not_null(game_day_instance.statistic, "Статистика должна быть создана")
	assert_true(game_day_instance.statistic is Statistic, "Статистика должна быть типа Statistic")

func test_start_opening_stage():
	game_day_instance.start_opening_stage()
	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.OPENING, "Текущая стадия должна быть OPENING")
	assert_not_null(game_day_instance.coffe_cup, "CoffeeCup должен быть создан")
	assert_not_null(game_day_instance.coffee_machine, "CoffeeMachine должен быть создан")
	assert_not_null(game_day_instance.milk_frother, "MilkFrother должен быть создан")
	assert_not_null(game_day_instance.client, "Client должен быть создан")
	assert_eq(game_day_instance.client_grades.size(), 0, "Список оценок клиента должен быть пустым")
	assert_false(game_day_instance.client_is_waiting, "client_is_waiting должен быть false")
	assert_false(game_day_instance.order_timer_is_start, "order_timer_is_start должен быть false")
	assert_eq(game_day_instance.passed_time, 0, "passed_time должен быть 0")

func test_start_game_stage():
	game_day_instance.start_game_stage()
	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.GAME, "Текущая стадия должна быть GAME")
	assert_eq(game_day_instance.number_seconds_in_day, 300, "number_seconds_in_day должен быть 600 секунд")
	assert_eq(game_day_instance.passed_seconds_in_day, 0.0, "passed_seconds_in_day должен быть 0")

func test_start_closing_stage():
	game_day_instance.start_closing_stage()
	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.CLOSING, "Текущая стадия должна быть CLOSING")

func test_end_closing_stage():
	game_day_instance.client = Client.new()
	game_day_instance.client.order_accept = true
	game_day_instance.client_grades.clear()
	game_day_instance.statistic = Statistic.new()
	
	game_day_instance.end_closing_stage()

	assert_eq(game_day_instance.stages_game.current_stage, StagesGame.Stage.STATISTIC, "Текущая стадия должна быть STATISTIC")

func test_clean_variables():
	game_day_instance.coffe_cup = CoffeeCup.new()
	game_day_instance.coffee_machine = CoffeeMachine.new()
	game_day_instance.milk_frother = MilkFrother.new()
	game_day_instance.client = Client.new()
	game_day_instance.client_is_waiting = true
	game_day_instance.order_timer_is_start = true
	game_day_instance.passed_time = 10.0
	game_day_instance.passed_seconds_in_day = 100.0
	
	game_day_instance.clean_variables()
	
	assert_null(game_day_instance.coffe_cup, "CoffeeCup должен быть null")
	assert_null(game_day_instance.coffee_machine, "CoffeeMachine должен быть null")
	assert_null(game_day_instance.milk_frother, "MilkFrother должен быть null")
	assert_null(game_day_instance.client, "Client должен быть null")
	assert_eq(game_day_instance.client_grades.size(), 0, "Список оценок клиента должен быть пустым")
	assert_false(game_day_instance.client_is_waiting, "client_is_waiting должен быть false")
	assert_false(game_day_instance.order_timer_is_start, "order_timer_is_start должен быть false")
	assert_eq(game_day_instance.passed_time, 0, "passed_time должен быть 0")
	assert_eq(game_day_instance.passed_seconds_in_day, 0.0, "passed_seconds_in_day должен быть 0")

func test_comparison_order_with_drink_perfect_match():
	game_day_instance.client = Client.new()
	game_day_instance.coffe_cup = CoffeeCup.new()
	
	if Global.ingredients_list and Global.ingredients_list.ingredients.size() > 0:
		var ingredient = Global.ingredients_list.ingredients[0]
		var step_ingredient = {ingredient: 1}
		game_day_instance.client.order = Order.new()
		game_day_instance.client.order.step_ingredient = step_ingredient
		game_day_instance.coffe_cup.add_ingredient(ingredient, 1)
		
		var grade = game_day_instance.comparison_order_with_drink()
		assert_eq(grade, Global.progress.max_rating, "Оценка должна быть максимальной при идеальном совпадении")
	else:
		pending("Тест пропущен: нет доступных ингредиентов в тестовом файле")

func test_comparison_order_with_drink_empty_drink():
	game_day_instance.client = Client.new()
	game_day_instance.coffe_cup = CoffeeCup.new()
	
	if Global.ingredients_list and Global.ingredients_list.ingredients.size() > 0:
		var ingredient = Global.ingredients_list.ingredients[0]
		var step_ingredient = {ingredient: 1}
		game_day_instance.client.order = Order.new()
		game_day_instance.client.order.step_ingredient = step_ingredient
		game_day_instance.coffe_cup.added_ingredients.clear()
		
		var grade = game_day_instance.comparison_order_with_drink()
		assert_eq(grade, 1, "Оценка должна быть 1 при пустом напитке")
	else:
		pending("Тест пропущен: нет доступных ингредиентов в тестовом файле")

func test_create_new_client():
	game_day_instance.client = Client.new()
	game_day_instance.client.grade = 3
	game_day_instance.client_grades.clear()
	
	game_day_instance.create_new_client()
	
	assert_eq(game_day_instance.client_grades.size(), 1, "Оценка клиента должна быть добавлена в список")
	assert_eq(game_day_instance.client_grades[0], 3, "Оценка клиента должна быть 3")
	assert_not_null(game_day_instance.client, "Новый клиент должен быть создан")
	assert_true(game_day_instance.client is Client, "Новый клиент должен быть типа Client")

func test_start_waiting_client():
	game_day_instance.start_waiting_client()
	
	assert_true(game_day_instance.client_is_waiting, "client_is_waiting должен быть true")
	assert_not_null(game_day_instance.wait_timer, "wait_timer должен быть создан")
	assert_true(game_day_instance.wait_timer is Timer, "wait_timer должен быть типа Timer")
	assert_true(game_day_instance.wait_timer.one_shot, "wait_timer должен быть одноразовым")

func test_refuse_order():
	game_day_instance.client = Client.new()
	game_day_instance.statistic = Statistic.new()
	
	game_day_instance.refuse_order()
	
	assert_true(game_day_instance.client.order_accept, "order_accept должен быть true")
	assert_eq(game_day_instance.client.grade, 1, "Оценка клиента должна быть 1")
	assert_eq(game_day_instance.statistic.not_served_clients, 1, "not_served_clients должен увеличиться на 1")

func test_start_timer():
	game_day_instance.client = Client.new()
	game_day_instance.statistic = Statistic.new()
	
	game_day_instance.start_timer()
	
	assert_true(game_day_instance.client.order_accept, "order_accept должен быть true")
	assert_true(game_day_instance.order_timer_is_start, "order_timer_is_start должен быть true")
	assert_eq(game_day_instance.passed_time, 0, "passed_time должен быть 0")
	assert_eq(game_day_instance.statistic.served_clients, 1, "served_clients должен увеличиться на 1")

func test_end_timer():
	game_day_instance.order_timer_is_start = true
	game_day_instance.passed_time = 10.0
	
	game_day_instance.end_timer()
	
	assert_false(game_day_instance.order_timer_is_start, "order_timer_is_start должен быть false")
	assert_eq(game_day_instance.passed_time, 0, "passed_time должен быть 0")

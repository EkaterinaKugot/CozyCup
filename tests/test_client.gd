extends GutTest

var client_instance = null

var test_progress_path = "res://tests/test_files/test_progress.tres"
var test_recipes_path = "res://tests/test_files/test_recipes_list.tres"
var test_ingredients_path = "res://tests/test_files/test_ingredients_list.tres"
var test_order_data_path = "res://tests/test_files/test_order_data.tres"

func before_each():	
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
	
	client_instance = Client.new()
	
	assert_not_null(Global.progress, "Прогресс должен быть загружен")
	assert_not_null(Global.recipes_list, "Список рецептов должен быть загружен")
	assert_not_null(Global.ingredients_list, "Список ингредиентов должен быть загружен")
	assert_not_null(Global.order_data, "OrderData должен быть загружен")

func after_each():
	client_instance = null
	Global.progress = null
	Global.recipes_list = null
	Global.ingredients_list = null
	Global.order_data = null

func test_properties():
	# Проверка начальных значений
	assert_not_null(client_instance.client_texture, "client_texture должно быть установлено")
	assert_not_null(client_instance.order, "order должен быть установлен")
	assert_eq(client_instance.grade, 0, "grade должно быть 0 изначально")
	assert_false(client_instance.order_accept, "order_accept должно быть false изначально")

func test_client_texture():
	var texture = client_instance.client_texture
	print(texture)
	print(Global.order_data.clients)
	assert_true(Global.order_data.clients.has(texture), "client_texture должен быть из списка Global.order_data.clients")

func test_order_initialization():
	var order = client_instance.order
	assert_true(order is Order, "order должен быть типа Order")
	assert_not_null(order.recipe, "order.recipe должен быть установлен после make_order")
	assert_false(order.step_ingredient.is_empty(), "order.step_ingredient должен содержать ингредиенты")
	assert_true(order.price > 0, "order.price должен быть рассчитан")
	assert_true(order.text.length() > 0, "order.text должен быть сформирован")

func test_accept_order():
	client_instance.accept_order()
	assert_true(client_instance.order_accept, "order_accept должно быть true после accept_order")

func test_exceed_time():
	client_instance.exceed_time()
	assert_true(client_instance.order.time_is_exceeded, "order.time_is_exceeded должно быть true после exceed_time")

func test_random_client_texture():
	var texture = client_instance.random_client_texture()
	assert_true(Global.order_data.clients.has(texture), "random_client_texture должен возвращать текстуру из Global.order_data.clients")

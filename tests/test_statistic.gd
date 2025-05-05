extends GutTest

var statistic_instance = null

var test_progress_path = "res://tests/test_files/test_progress.tres"

func before_each():
	statistic_instance = Statistic.new()
	
	# Настраиваем Global с тестовым путем
	Global.progress_path = test_progress_path
	
	# Загружаем прогресс
	Global.load_progress()
	
	assert_not_null(Global.progress, "Прогресс должен быть загружен")

func after_each():
	statistic_instance = null
	Global.progress = null

func test_properties():
	# Проверка начальных значений
	assert_eq(statistic_instance.old_rating, 0.0, "old_rating должно быть 0.0 изначально")
	assert_eq(statistic_instance.new_rating, 0.0, "new_rating должно быть 0.0 изначально")
	assert_eq(statistic_instance.diff_rating, 0.0, "diff_rating должно быть 0.0 изначально")
	assert_eq(statistic_instance.served_clients, 0, "served_clients должно быть 0 изначально")
	assert_eq(statistic_instance.not_served_clients, 0, "not_served_clients должно быть 0 изначально")
	assert_eq(statistic_instance.full_clients, 0, "full_clients должно быть 0 изначально")
	assert_eq(statistic_instance.consumption, 0, "consumption должно быть 0 изначально")
	assert_eq(statistic_instance.income, 0, "income должно быть 0 изначально")
	assert_eq(statistic_instance.profit, 0, "profit должно быть 0 изначально")

func test_set_old_rating():
	Global.progress.rating = 5.0
	statistic_instance.set_old_rating()
	assert_eq(statistic_instance.old_rating, 5.0, "old_rating должно быть равно Global.progress.rating")

func test_set_new_rating():
	Global.progress.rating = 7.5
	statistic_instance.set_new_rating()
	assert_eq(statistic_instance.new_rating, 7.5, "new_rating должно быть равно Global.progress.rating")

func test_calculate_diff_rating():
	statistic_instance.old_rating = 5.0
	statistic_instance.new_rating = 7.5
	statistic_instance.calculate_diff_rating()
	assert_eq(statistic_instance.diff_rating, 2.5, "diff_rating должно быть new_rating - old_rating")

func test_add_served_clients():
	statistic_instance.add_served_clients()
	assert_eq(statistic_instance.served_clients, 1, "served_clients должно увеличиться на 1")
	statistic_instance.add_served_clients()
	assert_eq(statistic_instance.served_clients, 2, "served_clients должно увеличиться еще на 1")

func test_add_not_served_clients():
	statistic_instance.add_not_served_clients()
	assert_eq(statistic_instance.not_served_clients, 1, "not_served_clients должно увеличиться на 1")
	statistic_instance.add_not_served_clients()
	assert_eq(statistic_instance.not_served_clients, 2, "not_served_clients должно увеличиться еще на 1")

func test_calculate_full_clients():
	statistic_instance.served_clients = 3
	statistic_instance.not_served_clients = 2
	statistic_instance.calculate_full_clients()
	assert_eq(statistic_instance.full_clients, 5, "full_clients должно быть served_clients + not_served_clients")

func test_add_consumption():
	statistic_instance.add_consumption(50)
	assert_eq(statistic_instance.consumption, 50, "consumption должно увеличиться на 50")
	statistic_instance.add_consumption(25)
	assert_eq(statistic_instance.consumption, 75, "consumption должно увеличиться еще на 25")

func test_add_income():
	statistic_instance.add_income(100)
	assert_eq(statistic_instance.income, 100, "income должно увеличиться на 100")
	statistic_instance.add_income(50)
	assert_eq(statistic_instance.income, 150, "income должно увеличиться еще на 50")

func test_calculate_profit():
	statistic_instance.income = 200
	statistic_instance.consumption = 150
	statistic_instance.calculate_profit()
	assert_eq(statistic_instance.profit, 50, "profit должно быть income - consumption")

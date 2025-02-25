extends "res://addons/gut/test.gd"

var progress: Progress

func before_each():
	# Создаем объект Progress перед каждым тестом
	progress = Progress.new();

### Тесты для свойств
func test_default_values():
	# Проверка дефолтных значений
	assert_eq(progress.number_start, 0, "number_start должен быть 0 по умолчанию")
	assert_eq(progress.day, 1, "day должен быть 1 по умолчанию")
	assert_eq(progress.duration_day, 10, "duration_day должен быть 10 по умолчанию")
	assert_eq(progress.rating, 5.0, "rating должен быть 5 по умолчанию")
	assert_eq(progress.money, 100, "money должен быть 100 по умолчанию")
	assert_eq(progress.diamonds, 30, "diamonds должен быть 30 по умолчанию")
	assert_eq(progress.music, 7, "music должен быть 7 по умолчанию")
	assert_eq(progress.sounds, 7, "sounds должен быть 7 по умолчанию")
	assert_eq(progress.opened_ingredients.size(), 0, "opened_ingredients должен быть пустым по умолчанию")
	assert_eq(progress.opened_recipes.size(), 0, "opened_recipes должен быть пустым по умолчанию")

func test_setters_validation():
	# Проверка валидации сеттеров
	# number_start
	progress.number_start = 10
	assert_eq(progress.number_start, 10, "number_start должен быть 10")

	# day
	progress.day = 5
	assert_eq(progress.day, 5, "day должен быть 5")

	# duration_day
	progress.duration_day = 12
	assert_eq(progress.duration_day, 12, "duration_day должен быть 12")

	# rating
	progress.rating = 3.5
	assert_eq(progress.rating, 3.5, "rating должен быть 3.5")

	# money
	progress.money = 200
	assert_eq(progress.money, 200, "money должен быть 200")
	# Проверка на отрицательное значение
	watch_signals(progress)
	progress.money = -10
	assert_signal_emitted(progress, "not_enough_money", "Сигнал not_enough_money должен быть отправлен")
	assert_eq(progress.money, 200, "money не должен измениться при попытке установить отрицательное значение")

	# diamonds
	progress.diamonds = 50
	assert_eq(progress.diamonds, 50, "diamonds должен быть 50")
	# Проверка на отрицательное значение
	watch_signals(progress)
	progress.diamonds = -5
	assert_signal_emitted(progress, "not_enough_diamonds", "Сигнал not_enough_diamonds должен быть отправлен")
	assert_eq(progress.diamonds, 50, "diamonds не должен измениться при попытке установить отрицательное значение")

	# music и sounds
	progress.music = 5
	assert_eq(progress.music, 5, "music должен быть 5")

	progress.sounds = 8
	assert_eq(progress.sounds, 8, "sounds должен быть 8")

### Тесты для методов
func test_add_number_start():
	progress.add_number_start()
	assert_eq(progress.number_start, 1, "number_start должен увеличиться на 1")

func test_add_day():
	progress.add_day()
	assert_eq(progress.day, 2, "day должен увеличиться на 1")

func test_change_duration_day():
	progress.change_duration_day_on_12()
	assert_eq(progress.duration_day, 12, "duration_day должен измениться на 12")

	progress.change_duration_day_on_14()
	assert_eq(progress.duration_day, 14, "duration_day должен измениться на 14")

func test_change_rating():
	progress.change_rating(4.0)
	assert_eq(progress.rating, 4.5, "rating должен измениться на (5 + 4) / 2 = 4.5")

func test_money_operations():
	progress.add_money(50)
	assert_eq(progress.money, 150, "money должен увеличиться на 50")

	progress.sub_money(30)
	assert_eq(progress.money, 120, "money должен уменьшиться на 30")

func test_diamonds_operations():
	progress.add_diamonds(20)
	assert_eq(progress.diamonds, 50, "diamonds должен увеличиться на 20")

	progress.sub_diamonds(10)
	assert_eq(progress.diamonds, 40, "diamonds должен уменьшиться на 10")

func test_opened_ingredients():
	var ingredient = Ingredient.new()
	ingredient.id = "milk_001"

	progress.add_new_opened_ingredients(ingredient, 3)
	assert_eq(progress.opened_ingredients[ingredient], 3, "ingredient должен быть добавлен с количеством 3")

	progress.add_number_ingredient(ingredient, 2)
	assert_eq(progress.opened_ingredients[ingredient], 5, "Количество ingredient должно увеличиться на 2")

	progress.sub_number_ingredient(ingredient, 1)
	assert_eq(progress.opened_ingredients[ingredient], 4, "Количество ingredient должно уменьшиться на 1")

func test_opened_recipes():
	var recipe = Recipe.new()
	progress.add_new_opened_recipes(recipe)
	assert_eq(progress.opened_recipes.size(), 1, "recipe должен быть добавлен в opened_recipes")

func test_music_and_sounds_operations():
	progress.add_music(2)
	assert_eq(progress.music, 9, "music должен увеличиться на 2")

	progress.sub_music(1)
	assert_eq(progress.music, 8, "music должен уменьшиться на 1")

	progress.add_sounds(3)
	assert_eq(progress.sounds, 10, "sounds должен увеличиться на 3")

	progress.sub_sounds(2)
	assert_eq(progress.sounds, 8, "sounds должен уменьшиться на 2")

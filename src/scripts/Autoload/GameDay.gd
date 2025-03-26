# GameDay.gd
extends Node

var coffe_cup: CoffeeCup:
	get:
		return coffe_cup
	set(value):
		coffe_cup = value
var coffee_machine: CoffeeMachine:
	get:
		return coffee_machine
	set(value):
		coffee_machine = value
var milk_frother: MilkFrother:
	get:
		return milk_frother
	set(value):
		milk_frother = value

var statistics: Statistics:
	get:
		return statistics
	set(value):
		statistics = value

var client: Client:
	get:
		return client
	set(value):
		client = value
var client_grades: Array[int]:
	get:
		return client_grades
	set(value):
		client_grades = value
var client_is_waiting: bool = false
var wait_timer: Timer:
	get:
		return wait_timer
	set(value):
		wait_timer = value
const min_wait_timer: int = 5
const max_wait_timer: int = 60
const percentage_price_reduction: int = 15

var order_timer_is_start: bool = false
var passed_time: float = 0

var stages_game: StagesGame = StagesGame.new()
var number_seconds_in_day: int:
	get:
		return number_seconds_in_day
	set(value):
		number_seconds_in_day = value
var passed_seconds_in_day: float = 0.0:
	get:
		return passed_seconds_in_day
	set(value):
		passed_seconds_in_day = value

var current_scene: String = "Menu":
	get:
		return current_scene
	set(value):
		current_scene = value
const scenes: Dictionary = {
	"Menu": "res://src/scenes/menu.tscn",
	"Level": "res://src/scenes/level.tscn",
	"LevelBack": "res://src/scenes/level_back.tscn",
	"LevelLeft": "res://src/scenes/level_left.tscn",
	"LevelRight": "res://src/scenes/level_right.tscn",
	"Purchase": "res://src/scenes/purchase.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stages_game.start_menu_stage()
	
func start_purchase_stage() -> void:
	stages_game.start_purchase_stage()
	statistics = Statistics.new()
	statistics.set_old_rating()
	
func start_opening_stage() -> void:
	stages_game.start_opening_stage()
	coffe_cup = CoffeeCup.new()
	coffee_machine = CoffeeMachine.new()
	milk_frother = MilkFrother.new()
	
	client = Client.new()
	client_grades = []
	client_is_waiting = false
	
	order_timer_is_start = false
	passed_time = 0
	
	statistics = Statistics.new() # УБРАТЬ
	statistics.set_old_rating()
	
func start_game_stage() -> void:
	stages_game.start_game_stage()
	number_seconds_in_day = 60 * Global.progress.duration_day
	passed_seconds_in_day = 0.0

func start_closing_stage() -> void:
	stages_game.start_closing_stage()
	
func end_closing_stage() -> void:
	if client.order_accept:
		client.grade = 1
		client_grades.append(client.grade)
	
	# Обновление рейтинга
	print(client_grades)
	var sum_grades: float = 0.0
	for grade in client_grades:
		sum_grades += grade
		
	if sum_grades != 0.0:
		Global.progress.change_rating(sum_grades, client_grades.size())
	
	statistics.set_new_rating()
	statistics.calculate_diff_rating()
	statistics.calculate_full_clients()
	
	# Обновления дня
	Global.progress.add_day()
	
	clean_variables()

func clean_variables() -> void:
	stages_game.start_menu_stage()
	coffe_cup = null
	coffee_machine = null
	milk_frother = null
	
	client = null
	client_grades = []
	client_is_waiting = false
	
	order_timer_is_start = false
	passed_time = 0
	passed_seconds_in_day = 0.0

	
func end_client_service() -> void:
	# вызываем сравнение заказа и выставление оценки
	client.grade = comparison_order_with_drink()
	
	# обновляем оплату
	var price: int
	var percent: int = (Global.progress.max_rating - client.grade) * percentage_price_reduction
	if client.grade == 1:
		price = 0 # если оценка клиента = 1
	else:
		price = client.order.price - (client.order.price * percent / 100) # снижаем оплату за ошибки
	Global.progress.add_money(price)
	
	coffe_cup = CoffeeCup.new()
	
func comparison_order_with_drink() -> int:
	var grade: int = Global.progress.max_rating
	var reference = client.order.step_ingredient
	var drink: Dictionary = {}
	
	# Заполняем словарь drink на основе added_ingredients
	for ingredient in coffe_cup.added_ingredients:
		drink[ingredient.keys()[0]] = ingredient.values()[0]

	# Проверяем, если время превышено
	if client.order.time_is_exceeded:
		grade -= 1

	var ref_keys: Array = reference.keys()
	var drink_keys: Array = drink.keys()
	
	if drink_keys.size() == 0:
		grade = 1
		return grade
	
	# Словарь для отслеживания уже проверенных ингредиентов
	var sequence_incorrect = false
	
	# Проверка наличия ингредиентов
	for key in ref_keys:
		if not drink.has(key): # Ингредиент отсутствует в drink
			if sequence_incorrect: # сбита последовательность
				grade -= 1
			else:
				grade -= 2
				sequence_incorrect = true
	
	for key in drink_keys:
		if not reference.has(key): # Лишний ингредиент в drink
			if sequence_incorrect: # последовательность уже неверна
				grade -= 1
			else: # последовательность ещё неверна
				grade -= 2
				sequence_incorrect = true
			break

	if not sequence_incorrect: # проверяем последовательность если она ещё не сбита
		for i in range(ref_keys.size()):
			var ref_key = ref_keys[i]
			if drink_keys[i] != ref_key:
				grade -= 1
				break
				
	# проверяем количество
	for ref_key in ref_keys:
		if drink.has(ref_key) and drink[ref_key] != reference[ref_key]:
			if ref_key.category == Ingredient.Category.TOPPING and drink[ref_key] >= 3:
				pass
			else:
				grade -= 1
	# Убедимся, что оценка не опускается ниже 0
	grade = max(grade, 1)
	return grade
	
	
func create_new_client() -> void:
	client_grades.append(client.grade)
	client = Client.new()
	print(client_grades)

func start_waiting_client() -> void:
	client_is_waiting = true
	wait_timer = Timer.new()
	wait_timer.wait_time = int(randf_range(min_wait_timer, (max_wait_timer/Global.progress.rating)))
	wait_timer.one_shot = true
	wait_timer.connect("timeout", _on_wait_timer_timeout)
	add_child(wait_timer)
	wait_timer.start()

func _on_wait_timer_timeout() -> void:
	client_is_waiting = false
	wait_timer.queue_free()
	
func refuse_order() -> void:
	client.accept_order()
	client.grade = 1
	statistics.add_not_served_clients()
	
func start_timer() -> void:
	client.accept_order()
	order_timer_is_start = true # Запускаем таймер
	passed_time = 0 # Задаем время таймера
	statistics.add_served_clients()
	
func end_timer() -> void:
	order_timer_is_start = false
	passed_time = 0 
	
func _process(delta: float) -> void:
	if get_tree().paused:
		return
		
	if self.order_timer_is_start: 
		if self.passed_time < self.client.order.lead_time:
			self.passed_time += delta
		else:
			self.passed_time = 0 
			self.client.exceed_time()
			self.order_timer_is_start = false  # Останавливаем таймер
			print("timer закончился")
	
	if self.stages_game.current_stage == StagesGame.Stage.GAME:
		if self.passed_seconds_in_day < self.number_seconds_in_day:
			self.passed_seconds_in_day += delta
		else:
			start_closing_stage()

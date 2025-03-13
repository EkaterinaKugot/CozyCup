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

var order_timer_is_start: bool = false
var passed_time: float = 0

func start_game_day() -> void:
	coffe_cup = CoffeeCup.new()
	coffee_machine = CoffeeMachine.new()
	milk_frother = MilkFrother.new()
	client = Client.new()

func end_game_day() -> void:
	coffe_cup = null
	coffee_machine = null
	milk_frother = null
	client = null
	client_grades = []
	
func create_new_coffe_cup() -> void:
	# вызываем сравнение заказа
	client.grade = comparison_order_with_drink()
	coffe_cup = CoffeeCup.new()
	
func comparison_order_with_drink() -> int:
	var grade: int = 5
	var reference = client.order.step_ingredient
	var drink: Dictionary = {}
	
	# Заполняем словарь drink на основе added_ingredients
	for ingredient in coffe_cup.added_ingredients:
		drink[ingredient.keys()[0]] = ingredient.values()[0]
	print(reference)
	print(drink)
	print(client.order.time_is_exceeded)
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
	print("grade1 ", grade)
	if not sequence_incorrect: # проверяем последовательность если она ещё не сбита
		for i in range(ref_keys.size()):
			var ref_key = ref_keys[i]
			if drink_keys[i] != ref_key:
				grade -= 1
				break
	# проверяем количество
	print("grade2 ", grade)
	for ref_key in ref_keys:
		if drink.has(ref_key) and drink[ref_key] != reference[ref_key]:
			if ref_key.category == Ingredient.Category.TOPPING and drink[ref_key] >= 3:
				pass
			else:
				grade -= 1
	# Убедимся, что оценка не опускается ниже 0
	grade = max(grade, 1)
	print("grade3 ", grade)
	return grade
	
func create_new_client():
	client_grades.append(client.grade)
	client = Client.new()
	print(client_grades)

func start_waiting_client():
	client_is_waiting = true
	await get_tree().create_timer(5.0).timeout
	client_is_waiting = false

func refuse_order() -> void:
	client.accept_order()
	client.grade = 1
	
func start_timer() -> void:
	client.accept_order()
	order_timer_is_start = true # Запускаем таймер
	passed_time = 0 # Задаем время таймера
	
func end_timer() -> void:
	order_timer_is_start = false
	passed_time = 0 
	
func _process(delta: float) -> void:
	if self.order_timer_is_start: 
		if self.passed_time < self.client.order.lead_time:
			self.passed_time += delta
		else:
			self.passed_time = 0 
			self.client.exceed_time()
			self.order_timer_is_start = false  # Останавливаем таймер
			print("timer закончился")
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

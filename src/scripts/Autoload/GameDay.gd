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

func create_new_client():
	client_grades.append(client.grade)
	client = null
	client = Client.new()
	print(client_grades)

func start_waiting_client():
	client_is_waiting = true
	await get_tree().create_timer(5.0).timeout
	client_is_waiting = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

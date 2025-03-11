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

func start_game_day() -> void:
	coffe_cup = CoffeeCup.new()
	coffee_machine = CoffeeMachine.new()
	milk_frother = MilkFrother.new()

func end_game_day() -> void:
	coffe_cup = null
	coffee_machine = null
	milk_frother = null
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

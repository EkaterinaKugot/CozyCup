extends Node

class_name CoffeeMachine

signal max_number_grains

var number_water: int = 0:
	get:
		return number_water
	set(value):
		number_water = min(value, 10)
		
var number_grains: int = 0:
	get:
		return number_grains
	set(value):
		if value > 10:
			emit_signal("max_number_grains")
			return 
		number_grains = value

func add_number_water(value: int) -> void:
	number_water += value
	
func add_number_grains(value: int) -> void:
	number_grains += value

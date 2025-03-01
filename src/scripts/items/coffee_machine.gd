extends Area2D

var scene_filling_water = preload("res://src/scenes/game_elements/filling_water.tscn")
var instance_filling_water = scene_filling_water.instantiate()
var mini_game_is_start: bool = false

@onready var label_grains_container = $GrainsContainer/NumberGrains
	
func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			if shape_idx == 0:
				add_grains_pressed()
			elif shape_idx == 1:
				start_coffee_pressed()
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			if shape_idx == 0:
				add_grains_pressed()
			elif shape_idx == 1:
				start_coffee_pressed()

func add_grains_pressed() -> void:
	var number = 1
	#if CoffeeMachine.check_number_grains(, number) and Global.progress.check_number_ingredient(, number):
		#CoffeeMachine.add_number_grains(, number)
		#label_grains_container.text = CoffeeMachine.number_grains
		#Global.progress.sub_number_ingredient(, number)
		#if check_condition_mini_game():
			#start_mini_game()

func start_coffee_pressed() -> void:
	if CoffeeMachine.number_water >= CoffeeMachine.number_grains:
		pass
	
func check_condition_mini_game() -> bool:
	return not mini_game_is_start and CoffeeMachine.number_water < CoffeeMachine.number_grains
	
func start_mini_game() -> void:
	mini_game_is_start = true
	
	get_parent().add_child(instance_filling_water)
	instance_filling_water.position = Vector2(250, 400)
	instance_filling_water.get_child(0).connect("water_compartment_full", end_mini_game)
	
	print(instance_filling_water.get_child(0).get_child(0).visible)

func end_mini_game() -> void:
	if instance_filling_water != null:
		instance_filling_water.queue_free()

	CoffeeMachine.fill_number_water()
	mini_game_is_start = false

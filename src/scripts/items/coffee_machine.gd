extends Area2D

var scene_filling_water = preload("res://src/scenes/game_elements/filling_water.tscn")
var instance_filling_water = scene_filling_water.instantiate()

@onready var label_grains_container = $GrainsContainer.get_node("NumberGrains")
@onready var coffee_kettle_progress = $CoffeeKettle/CoffeeKettleProgress

func _ready() -> void:
	update_label_grains_container()
	CoffeeMachine.mini_game_is_start = false
	if check_condition_mini_game():
		start_mini_game()
	
func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			var current_ingredient = get_parent().current_ingredient
			if shape_idx == 0 and current_ingredient != null and \
			current_ingredient.category == Ingredient.Category.GRAINS:
				add_grains_pressed(current_ingredient)
			elif shape_idx == 1:
				start_coffee_pressed(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			var current_ingredient = get_parent().current_ingredient
			if shape_idx == 0 and current_ingredient != null and \
			current_ingredient.category == Ingredient.Category.GRAINS:
				add_grains_pressed(current_ingredient)
			elif shape_idx == 1:
				start_coffee_pressed(current_ingredient)

func add_grains_pressed(current_ingredient: Ingredient) -> void:
	var number = 1
	if CoffeeMachine.check_number_grains(current_ingredient.id, number) and \
	Global.progress.check_number_ingredient(current_ingredient, number):
		CoffeeMachine.add_number_grains(number)
		update_label_grains_container() # обновили значение у бака зерен
		CoffeeMachine.id_grains = current_ingredient.id # сменили id
		
		Global.progress.sub_number_ingredient(current_ingredient, number) # обновили progress
		get_parent().instances_ingredients[
			current_ingredient.category
			][current_ingredient].update_number() # обновили значение у ингредиента
		if check_condition_mini_game():
			start_mini_game()

func update_label_grains_container() -> void:
	label_grains_container.text = str(CoffeeMachine.number_grains)
	
func start_coffee_pressed(current_ingredient: Ingredient) -> void:
	if CoffeeMachine.number_water >= CoffeeMachine.number_grains and \
	CoffeeMachine.number_grains > 0 and current_ingredient == null:
		coffee_kettle_progress.start_progress()
	
func check_condition_mini_game() -> bool:
	return not CoffeeMachine.mini_game_is_start and CoffeeMachine.number_water < CoffeeMachine.number_grains
	
func start_mini_game() -> void:
	CoffeeMachine.mini_game_is_start = true
	print(instance_filling_water)
	add_child(instance_filling_water)
	instance_filling_water.position = Vector2(100, -120)
	instance_filling_water.get_node("ProgressFillingWater").connect("water_compartment_full", end_mini_game)

func end_mini_game() -> void:
	if instance_filling_water != null:
		instance_filling_water.queue_free()
		
	instance_filling_water = scene_filling_water.instantiate()
	CoffeeMachine.fill_number_water()
	CoffeeMachine.mini_game_is_start = false

extends Area2D

var scene_filling_water = preload("res://src/scenes/game_elements/filling_water.tscn")
var instance_filling_water = scene_filling_water.instantiate()

@onready var grains_container = $IngredientsContainer
@onready var coffee_kettle = $CoffeeKettle

signal disabled_bottom_hud()
signal undisabled_bottom_hud()

func _ready() -> void:
	grains_container.get_node("Icon").texture = load("res://assets/icons/grains_medium_icon.png")
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
			elif shape_idx == 1 and not CoffeeMachine.coffee_is_ready:
				start_coffee_pressed(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			var current_ingredient = get_parent().current_ingredient
			if shape_idx == 0 and current_ingredient != null and \
			current_ingredient.category == Ingredient.Category.GRAINS:
				add_grains_pressed(current_ingredient)
			elif shape_idx == 1 and not CoffeeMachine.coffee_is_ready:
				start_coffee_pressed(current_ingredient)

func add_grains_pressed(current_ingredient: Ingredient) -> void:
	var number = 1
	if CoffeeMachine.check_number_grains(current_ingredient, number) and \
	Global.progress.check_number_ingredient(current_ingredient, number):
		CoffeeMachine.add_number_grains(number)
		update_label_grains_container() # визуально обновили значение у бака зерен
		CoffeeMachine.ingredient = current_ingredient # сменили ингредиент
		
		Global.progress.sub_number_ingredient(current_ingredient, number) # обновили progress
		get_parent().instances_ingredients[
			current_ingredient.category
			][current_ingredient].update_number() # визуально обновили значение у ингредиента
		if check_condition_mini_game():
			start_mini_game()

func update_label_grains_container() -> void:
	grains_container.get_node("Number").text = str(CoffeeMachine.number_grains)
	
func start_coffee_pressed(current_ingredient: Ingredient) -> void:
	if CoffeeMachine.number_water >= CoffeeMachine.number_grains and \
	CoffeeMachine.number_grains > 0 and current_ingredient == null:
		coffee_kettle.get_node("CoffeeKettleProgress").start_progress()
		disabled_bottom_hud.emit()
	
func check_condition_mini_game() -> bool:
	return not CoffeeMachine.mini_game_is_start and CoffeeMachine.number_water < CoffeeMachine.number_grains
	
func start_mini_game() -> void:
	CoffeeMachine.mini_game_is_start = true
	add_child(instance_filling_water)
	instance_filling_water.position = Vector2(100, -120)
	instance_filling_water.get_node("ProgressFillingWater").connect("water_compartment_full", end_mini_game)

func end_mini_game() -> void:
	if instance_filling_water != null:
		instance_filling_water.queue_free()
		
	instance_filling_water = scene_filling_water.instantiate()
	CoffeeMachine.fill_number_water()
	CoffeeMachine.mini_game_is_start = false


func _on_coffee_cup_clean_coffee_kettle() -> void:
	coffee_kettle.visible = false
	coffee_kettle.get_node("CoffeeKettleProgress").value = 0


func _undisabled_bottom_hud() -> void:
	undisabled_bottom_hud.emit()

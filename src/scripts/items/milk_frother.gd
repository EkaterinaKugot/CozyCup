extends Area2D

@onready var milk_container = $IngredientsContainer
@onready var milk_kettle = $MilkKettle

signal disabled_bottom_hud()
signal undisabled_bottom_hud()

func _ready() -> void:
	milk_container.get_node("Icon").texture = load("res://assets/icons/milk_cow_icon.png")
	update_label_milk_container()

func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			var current_ingredient = get_parent().current_ingredient
			if shape_idx == 0 and current_ingredient != null and \
			(current_ingredient.category == Ingredient.Category.MILK or \
			current_ingredient.category == Ingredient.Category.CREAM):
				add_milk_pressed(current_ingredient)
			elif shape_idx == 1 and not MilkFrother.milk_is_ready:
				start_milk_pressed(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			var current_ingredient = get_parent().current_ingredient
			if shape_idx == 0 and current_ingredient != null and \
			(current_ingredient.category == Ingredient.Category.MILK or \
			current_ingredient.category == Ingredient.Category.CREAM):
				add_milk_pressed(current_ingredient)
			elif shape_idx == 1 and not MilkFrother.milk_is_ready:
				start_milk_pressed(current_ingredient)

func add_milk_pressed(current_ingredient: Ingredient) -> void:
	var number = 1
	if MilkFrother.check_number_milk(current_ingredient, number) and \
	Global.progress.check_number_ingredient(current_ingredient, number):
		MilkFrother.add_number_milk(number)
		update_label_milk_container() # визуально обновили значение у бака зерен
		MilkFrother.ingredient = current_ingredient # сменили ингредиент
		
		Global.progress.sub_number_ingredient(current_ingredient, number) # обновили progress
		get_parent().instances_ingredients[
			current_ingredient.category
			][current_ingredient].update_number() # визуально обновили значение у ингредиента

func start_milk_pressed(current_ingredient: Ingredient) -> void:
	if MilkFrother.number_milk > 0 and current_ingredient == null:
		milk_kettle.get_node("MilkKettleProgress").start_progress()
		disabled_bottom_hud.emit()

func update_label_milk_container() -> void:
	milk_container.get_node("Number").text = str(MilkFrother.number_milk)


func _on_coffee_cup_clean_milk_kettle() -> void:
	milk_kettle.visible = false
	milk_kettle.get_node("MilkKettleProgress").value = 0


func _undisabled_bottom_hud() -> void:
	undisabled_bottom_hud.emit()

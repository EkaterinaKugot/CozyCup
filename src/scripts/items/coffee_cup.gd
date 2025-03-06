extends Area2D

@onready var glow_effect = $GlowEffect
@onready var coffee_kettle = $"../CoffeeMachine/CoffeeKettle"
@onready var milk_kettle = $"../MilkFrother/MilkKettle"

var coffee_cup_ingredient = preload("res://src/scenes/game_elements/coffee_cup_ingredient.tscn")
var dict_instance: Dictionary = {}

signal clean_coffee_kettle()
signal clean_milk_kettle()

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	coffee_kettle.connect("сoffee_delivered", add_grains_ingredient)
	milk_kettle.connect("milk_delivered", add_milk_ingredient)
	
	display_ingredients()
	
func _input_event(_viewport, event, shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category == Ingredient.Category.WATER:
				add_water_ingredient(current_ingredient)
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var current_ingredient = get_parent().current_ingredient
			if current_ingredient != null and \
			current_ingredient.category == Ingredient.Category.WATER:
				add_water_ingredient(current_ingredient)
		
	
func add_grains_ingredient() -> void:
	CoffeeCup.add_ingredient(
		CoffeeMachine.ingredient_in_kettle, CoffeeMachine.number_coffee_shots
	) # добавили в кружку
	
	CoffeeMachine.clean_coffee_kettle() # очистили чайник
	clean_coffee_kettle.emit()
	
	display_ingredients()  # отображаем ингредиенты

func add_milk_ingredient() -> void:
	CoffeeCup.add_ingredient(
		MilkFrother.ingredient_in_kettle, MilkFrother.number_milk_shots
	) # добавили в кружку
	
	MilkFrother.clean_milk_kettle() # очистили чайник
	clean_milk_kettle.emit()
	
	display_ingredients()  # отображаем ингредиенты
	
func add_water_ingredient(current_ingredient: Ingredient) -> void:
	CoffeeCup.add_ingredient(
		current_ingredient, 1
	) # добавили в кружку
	
	display_ingredients()  # отображаем ингредиенты
	
func display_ingredients() -> void:
	var array_ingredients = CoffeeCup.array_ingredients() 
	var y = 50
	for ingredient in array_ingredients: # отображаем добавленное
		var instance_coffee_cup_ingredient
		if ingredient in dict_instance.keys():
			instance_coffee_cup_ingredient = dict_instance[ingredient]
		else:
			instance_coffee_cup_ingredient = coffee_cup_ingredient.instantiate()
			var icon = instance_coffee_cup_ingredient.get_node("Icon") # добавляем иконку
			icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
			instance_coffee_cup_ingredient.position = Vector2(55, y) # устанавливаем позицию
			
			add_child(instance_coffee_cup_ingredient)
			
		var label_number = instance_coffee_cup_ingredient.get_node("Number") # обновляем количество
		label_number.text = str(CoffeeCup.added_ingredients[ingredient])
		
		dict_instance[ingredient] = instance_coffee_cup_ingredient
		y -= 30
	print("array_ingredients: ", array_ingredients)
	print("dict_instance: ", dict_instance)
	
# Срабатывает при входе в другую область
func _on_area_entered(area: Area2D):
	if area != self:  # Исключаем саму себя
		glow_effect.visible = true

# Срабатывает при выходе из другой области
func _on_area_exited(area: Area2D):
	if area != self:
		glow_effect.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

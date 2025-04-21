extends "res://src/scripts/items/base_coffee_cup.gd"

@onready var glow_effect = $GlowEffect
@onready var coffee_kettle = $"../CoffeeMachine/CoffeeKettle"
@onready var milk_kettle = $"../MilkFrother/MilkKettle"

signal clean_coffee_kettle()
signal clean_milk_kettle()

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	coffee_kettle.connect("coffee_delivered", add_grains_ingredient)
	milk_kettle.connect("milk_delivered", add_milk_ingredient)
	
	display_ingredients()
	
func add_grains_ingredient() -> void:
	Audio.play_sound(Audio.sound_player, "liquid")
	GameDay.coffe_cup.add_ingredient(
		GameDay.coffee_machine.ingredient_in_kettle, GameDay.coffee_machine.number_coffee_shots
	) # добавили в кружку
	
	GameDay.coffee_machine.clean_coffee_kettle() # очистили чайник
	clean_coffee_kettle.emit()
	
	display_ingredients()  # отображаем ингредиенты

func add_milk_ingredient() -> void:
	Audio.play_sound(Audio.sound_player, "liquid")
	GameDay.coffe_cup.add_ingredient(
		GameDay.milk_frother.ingredient_in_kettle, GameDay.milk_frother.number_milk_shots
	) # добавили в кружку
	
	GameDay.milk_frother.clean_milk_kettle() # очистили чайник
	clean_milk_kettle.emit()
	
	display_ingredients()  # отображаем ингредиенты
	
# Срабатывает при входе в другую область
func _on_area_entered(area: Area2D):
	if area != self:  # Исключаем саму себя
		glow_effect.visible = true

# Срабатывает при выходе из другой области
func _on_area_exited(area: Area2D):
	if area != self:
		glow_effect.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

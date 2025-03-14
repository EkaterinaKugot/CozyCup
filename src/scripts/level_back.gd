extends "res://src/scripts/base_level.gd"

@onready var jug_water = $JugWater
var scene_grain_package = preload("res://src/scenes/items/grain_package.tscn")
var scene_milk = preload("res://src/scenes/items/milk.tscn")

@onready var milk_frother = $MilkFrother

var WIDTH
var HEIGHT

func _ready() -> void:
	current_ingredient = null

	opened_ingredients = {}
	instances_ingredients = {}
	value_properties = {}
	
	WIDTH = get_viewport().size.x
	HEIGHT = get_viewport().size.y
	milk_frother.position = Vector2(1150, 475)
	value_properties = {
		Ingredient.Category.GRAINS: {
			"position": Vector2(80, 190), "scale": Vector2(0.45, 0.45), "idx_position": 1
		}, 
		Ingredient.Category.MILK: {
			"position": Vector2(1200, 190), "scale": Vector2(0.5, 0.5), "idx_position": -1
		},
		Ingredient.Category.CREAM: {
			"position": Vector2(900, 475), "scale": Vector2(0.7, 0.7), "idx_position": 1
		}
	}
	
	opened_ingredients[Ingredient.Category.GRAINS] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.GRAINS
	)
	opened_ingredients[Ingredient.Category.MILK] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.MILK
	)
	opened_ingredients[Ingredient.Category.WATER] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.WATER
	)
	opened_ingredients[Ingredient.Category.CREAM] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.CREAM
	)
	
	instances_ingredients[Ingredient.Category.GRAINS] = load_ingredients(
		opened_ingredients[Ingredient.Category.GRAINS], scene_grain_package
	)
	instances_ingredients[Ingredient.Category.MILK] = load_ingredients(
		opened_ingredients[Ingredient.Category.MILK], scene_milk
	)
	instances_ingredients[Ingredient.Category.CREAM] = load_ingredients(
		opened_ingredients[Ingredient.Category.CREAM], scene_milk # ПОМЕНЯТЬ
	)

	instances_ingredients[Ingredient.Category.WATER] = {
		opened_ingredients[Ingredient.Category.WATER].keys()[0]: jug_water
	}
	jug_water.ingredient = instances_ingredients[Ingredient.Category.WATER].keys()[0]
	jug_water.connect("ingredient_pressed", change_current_ingredient)
	

func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")

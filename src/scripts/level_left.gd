extends "res://src/scripts/base_level.gd"

var scene_syrup = preload("res://src/scenes/items/syrup.tscn")
var scene_topping = preload("res://src/scenes/items/topping.tscn")
var scene_ice_cream = preload("res://src/scenes/items/ice_cream.tscn")

@onready var sugar = $Sugar
@onready var bottom_hud: CanvasLayer = $BottomHud

func _ready() -> void:
	current_ingredient = null

	opened_ingredients = {}
	instances_ingredients = {}
	value_properties = {}
	
	value_properties = {
		Ingredient.Category.SYRUP: {
			"position": Vector2(80, 210), "scale": Vector2(0.55, 0.55), "idx_position": 1
		}, 
		Ingredient.Category.TOPPING: {
			"position": Vector2(100, 475), "scale": Vector2(0.6, 0.6), "idx_position": 1
		},
		Ingredient.Category.ICE_CREAM: {
			"position": Vector2(960, 475), "scale": Vector2(0.75, 0.7), "idx_position": 1
		}
	}
	
	opened_ingredients[Ingredient.Category.SUGAR] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.SUGAR
	)
	opened_ingredients[Ingredient.Category.SYRUP] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.SYRUP
	)
	opened_ingredients[Ingredient.Category.TOPPING] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.TOPPING
	)
	opened_ingredients[Ingredient.Category.ICE_CREAM] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.ICE_CREAM
	)
	
	instances_ingredients[Ingredient.Category.SYRUP] = load_ingredients(
		opened_ingredients[Ingredient.Category.SYRUP], scene_syrup, true
	)
	instances_ingredients[Ingredient.Category.TOPPING] = load_ingredients(
		opened_ingredients[Ingredient.Category.TOPPING], scene_topping, true
	)
	instances_ingredients[Ingredient.Category.ICE_CREAM] = load_ingredients(
		opened_ingredients[Ingredient.Category.ICE_CREAM], scene_ice_cream
	)
	instances_ingredients[Ingredient.Category.SUGAR] = {
		opened_ingredients[Ingredient.Category.SUGAR].keys()[0]: sugar
	} 
	assert(instances_ingredients[
		Ingredient.Category.SUGAR
		].size() == opened_ingredients[
			Ingredient.Category.SUGAR
		].size(), "The sizes should be equal"
	)
	sugar.ingredient = opened_ingredients[Ingredient.Category.SUGAR].keys()[0]
	sugar.update_number()
	sugar.connect("ingredient_pressed", change_current_ingredient)

func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_back.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")

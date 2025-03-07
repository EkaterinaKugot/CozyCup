extends "res://src/scripts/base_level.gd"

var scene_syrup = preload("res://src/scenes/items/syrup.tscn")
var scene_topping = preload("res://src/scenes/items/topping.tscn")

@onready var sugar = $Sugar

func _ready() -> void:
	current_ingredient = null

	opened_ingredients = {}
	instances_ingredients = {}
	value_properties = {}
	
	emit_signal("level_hud_visible")
	
	value_properties = {
		Ingredient.Category.SWEETNESS: {
			"position": Vector2(80, 210), "scale": Vector2(0.6, 0.6), "idx_position": 1
		}, 
		Ingredient.Category.TOPPING: {
			"position": Vector2(100, 475), "scale": Vector2(0.6, 0.6), "idx_position": 1
		},
		Ingredient.Category.ICE_CREAM: {
			"position": Vector2(950, 475), "scale": Vector2(0.7, 0.7), "idx_position": 1
		}
	}
	
	opened_ingredients[Ingredient.Category.SWEETNESS] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.SWEETNESS
	)
	opened_ingredients[Ingredient.Category.TOPPING] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.TOPPING
	)
	opened_ingredients[Ingredient.Category.ICE_CREAM] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.ICE_CREAM
	)
	
	instances_ingredients[Ingredient.Category.SWEETNESS] = load_ingredients(
		opened_ingredients[Ingredient.Category.SWEETNESS], scene_syrup, true
	)
	instances_ingredients[Ingredient.Category.TOPPING] = load_ingredients(
		opened_ingredients[Ingredient.Category.TOPPING], scene_topping, true
	)
	instances_ingredients[Ingredient.Category.ICE_CREAM] = load_ingredients(
		opened_ingredients[Ingredient.Category.ICE_CREAM], scene_topping # ПОМЕНЯТЬ
	)
	
	var ingredient_sugar: Ingredient
	for ing in opened_ingredients[Ingredient.Category.SWEETNESS].keys():
		if ing.id == "sugar":
			ingredient_sugar = ing
			instances_ingredients[Ingredient.Category.SWEETNESS][ingredient_sugar] = sugar
			break
	assert(ingredient_sugar != null, "The value of the variable ingredient_sugar is not defined")
	sugar.ingredient = ingredient_sugar
	sugar.update_number()
	sugar.connect("ingredient_pressed", change_current_ingredient)

func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_back.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")

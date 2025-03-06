extends Control

var scene_syrup = preload("res://src/scenes/items/syrup.tscn")
var scene_topping = preload("res://src/scenes/items/topping.tscn")

var opened_ingredients: Dictionary
var instances_ingredients: Dictionary
var value_properties: Dictionary 

var current_ingredient: Ingredient = null

signal level_hud_visible()

func _ready() -> void:
	emit_signal("level_hud_visible")
	
	value_properties = {
		Ingredient.Category.SWEETNESS: {
			"position": Vector2(80, 190), "scale": Vector2(0.7, 0.7), "idx_position": 1
		}, 
		Ingredient.Category.TOPPING: {
			"position": Vector2(80, 475), "scale": Vector2(0.7, 0.7), "idx_position": 1
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_back.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")

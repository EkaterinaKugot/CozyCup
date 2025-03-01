extends Control

var scene_grain_package = preload("res://src/scenes/items/grain_package.tscn")
var scene_milk = preload("res://src/scenes/items/milk.tscn")

var opened_grains: Dictionary = Global.progress.select_ingredients_by_category(Ingredient.Category.GRAINS)
var opened_milk: Dictionary = Global.progress.select_ingredients_by_category(Ingredient.Category.MILK)

var grain_package_instances: Dictionary = {}
var milk_instances: Dictionary = {}
var start_position_grain_package = Vector2(80, 180)
var start_position_milk = Vector2(1220, 180)

var current_ingredient: Ingredient = null

signal level_hud_visible()

func _ready() -> void:
	emit_signal("level_hud_visible")
	grain_package_instances = load_ingredients(opened_grains, scene_grain_package)
	milk_instances = load_ingredients(opened_milk, scene_milk)
	
func load_ingredients(dict: Dictionary, scene) -> Dictionary:
	var result = {}
	var size_scale_grains = Vector2(0.4, 0.4)
	var size_scale_milk = Vector2(0.45, 0.45)
	var count = 0
	
	for ingredient in dict.keys():
		var instance = scene.instantiate()
		instance.connect("ingredient_pressed", change_current_ingredient)
		instance.ingredient = ingredient
		var size_x = (100 * count) + 10
		
		var sprite = instance.get_node("Sprite2D")
		if sprite:
			sprite.texture = load("res://assets/items/{0}.png".format([ingredient.id]))

		if ingredient.category == Ingredient.Category.GRAINS:
			instance.scale = size_scale_grains
			instance.position = start_position_grain_package
			instance.position.x += size_x
		elif ingredient.category == Ingredient.Category.MILK:
			instance.scale = size_scale_milk
			instance.position = start_position_milk
			instance.position.x -= size_x
			
		result[instance] = dict[ingredient]
		
		add_child(instance)
		count += 1
	return result
		
func change_current_ingredient(ingredient: Ingredient) -> void:
	if current_ingredient == ingredient:
		current_ingredient = null
	elif current_ingredient == null:
		current_ingredient = ingredient
	else:
		var instance = find_instance_by_ingredients(current_ingredient)
		var glow_effect = instance.get_node("GlowEffect")
		glow_effect.visible = not glow_effect.visible
		
		current_ingredient = ingredient
	print(current_ingredient)

func find_instance_by_ingredients(ingredient: Ingredient):
	var instance
	if ingredient.category == Ingredient.Category.GRAINS:
		instance = find_instance(ingredient, opened_grains, grain_package_instances)
	elif ingredient.category == Ingredient.Category.MILK:
		instance = find_instance(ingredient, opened_milk, milk_instances)
	return instance
	
func find_instance(ingredient: Ingredient, opened_items: Dictionary, opened_instances: Dictionary):
	var count = 0
	for i in opened_items.keys():
		if i == ingredient:
			break
		count += 1
	var count2 = 0
	for instance in opened_instances.keys():
		if count2 == count:
			return instance
		count2 += 1		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")

extends Control

var current_ingredient: Ingredient = null

var opened_ingredients: Dictionary
var instances_ingredients: Dictionary
var value_properties: Dictionary 
	
func load_ingredients(ingredients: Dictionary, scene, has_icon: bool = false) -> Dictionary:
	var result = {}
	var count = 0
	
	for ingredient in ingredients.keys():
		var instance = scene.instantiate()
		instance.connect("ingredient_pressed", change_current_ingredient)
		instance.ingredient = ingredient
		var n: int = 100
		if ingredient.category == Ingredient.Category.GRAINS or \
		ingredient.category == Ingredient.Category.TOPPING:
			n = 150
		if ingredient.category == Ingredient.Category.MILK:
			n = 90
		var size_x = (n * count) + 10
		
		var sprite = instance.get_node("Sprite2D")
		if sprite:
			if not has_icon:
				sprite.texture = load("res://assets/items/{0}.png".format([ingredient.id]))
			else:
				var icon = sprite.get_node("Icon")
				icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
		instance.scale = value_properties[ingredient.category]["scale"]
		instance.position = value_properties[ingredient.category]["position"]
		instance.position.x += size_x * value_properties[ingredient.category]["idx_position"]
			
		result[ingredient] = instance
		
		add_child(instance)
		instance.update_number()
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
		if current_ingredient.category == Ingredient.Category.SYRUP:
			instance.delete_mini_game()
		
		current_ingredient = ingredient

func find_instance_by_ingredients(ingredient: Ingredient):
	var instance
	for ingr in instances_ingredients[ingredient.category].keys():
		if ingr == ingredient:
			instance = instances_ingredients[ingredient.category][ingr]
			break
			
	assert(instance != null, "The value of instance cannot be null")
	return instance

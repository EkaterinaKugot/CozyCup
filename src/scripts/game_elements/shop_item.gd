extends Control

@onready var name_item: Label = $MarginContainer/VBoxContainer/Name
@onready var price: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Price

@onready var recipe_element: HBoxContainer = $MarginContainer/VBoxContainer/RecipeElement
@onready var ingredient_element: HBoxContainer = $MarginContainer/VBoxContainer/IngredientElement

@onready var recipe_image: TextureRect = $MarginContainer/VBoxContainer/RecipeElement/Image
@onready var recipe_label: Label = $MarginContainer/VBoxContainer/RecipeElement/Label

@onready var ingredient_image: TextureRect = $MarginContainer/VBoxContainer/IngredientElement/Image
@onready var ingredient_icon: TextureRect = $MarginContainer/VBoxContainer/IngredientElement/Image/Icon

@onready var open: Button = $MarginContainer/VBoxContainer/Open

var item # Ingredient or Recipe
var min_size: Vector2 = Vector2(70, 70)

signal open_item(item)

func _ready() -> void:
	open.pressed.connect(on_open_pressed)
	
func on_open_pressed() -> void:
	open_item.emit(item)

func _on_shop_recipes_pressed() -> void:
	recipe_element.visible = true
	ingredient_element.visible = false


func _on_shop_ingredients_pressed() -> void:
	recipe_element.visible = false
	ingredient_element.visible = true


func _on_shop_clear_items() -> void:
	name_item.text = ""
	price.text = str(0)
	
	recipe_image.texture = null
	recipe_label.text = ""
	
	ingredient_image.texture = null
	ingredient_icon.texture = null
	
	open.disabled = false
	visible = false


func _on_shop_recipe_visible(recipe: Recipe) -> void:
	item = recipe
	
	name_item.text = recipe.name
	price.text = str(recipe.unlock_cost)
	
	recipe_image.texture = load("res://assets/recipes/{0}.png".format([recipe.id]))
	recipe_label.text = recipe.description
	
	if not Global.progress.check_money(recipe.unlock_cost):
		open.disabled = true
	visible = true


func _on_shop_ingredient_visible(ingredient: Ingredient) -> void:
	item = ingredient
	
	name_item.text = ingredient.name
	price.text = str(ingredient.unlock_cost)
	
	if ingredient.category == Ingredient.Category.SYRUP:
		ingredient_image.texture = load("res://assets/items/syrup.png")
		ingredient_icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
		ingredient_icon.custom_minimum_size = min_size
		ingredient_icon.size = ingredient_icon.custom_minimum_size
	elif ingredient.category == Ingredient.Category.TOPPING:
		ingredient_image.texture = load("res://assets/items/topping_packet.png")
		ingredient_icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
		ingredient_icon.custom_minimum_size = min_size + Vector2(20, 20)
		ingredient_icon.size = ingredient_icon.custom_minimum_size
	else:
		ingredient_image.texture = load("res://assets/items/{0}.png".format([ingredient.id]))
		ingredient_icon.texture = null
		
	if not Global.progress.check_money(ingredient.unlock_cost):
		open.disabled = true
		
	visible = true

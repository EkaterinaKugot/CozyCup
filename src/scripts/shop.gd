extends Control

@onready var close: Button = $MarginContainer2/Close

@onready var recipes: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Recipes
@onready var ingredients: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Ingredients
@onready var improvements: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Improvements

@onready var recipe_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/RecipeContainer
@onready var ingredient_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/IngredientContainer
@onready var improvement_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/ImprovementContainer

signal recipes_pressed
signal ingredients_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close.pressed.connect(on_close_pressed)
	recipes.pressed.connect(on_recipes_pressed)
	ingredients.pressed.connect(on_ingredients_pressed)
	improvements.pressed.connect(on_improvements_pressed)

func on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")
	
func on_recipes_pressed() -> void:
	recipe_container.visible = true
	ingredient_container.visible = false
	improvement_container.visible = false
	recipes_pressed.emit()
	
func on_ingredients_pressed() -> void:
	recipe_container.visible = false
	ingredient_container.visible = true
	improvement_container.visible = false
	ingredients_pressed.emit()
	
func on_improvements_pressed() -> void:
	recipe_container.visible = false
	ingredient_container.visible = false
	improvement_container.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

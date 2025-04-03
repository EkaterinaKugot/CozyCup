extends Control

@onready var name_item: Label = $MarginContainer/VBoxContainer/Name
@onready var price: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Price

@onready var recipe_element: HBoxContainer = $MarginContainer/VBoxContainer/RecipeElement
@onready var ingredient_element: HBoxContainer = $MarginContainer/VBoxContainer/IngredientElement

@onready var recipe_image: TextureRect = $MarginContainer/VBoxContainer/RecipeElement/Image
@onready var recipe_label: Label = $MarginContainer/VBoxContainer/RecipeElement/Label

@onready var ingredient_image: TextureRect = $MarginContainer/VBoxContainer/IngredientElement/Image
@onready var ingredient_icon: TextureRect = $MarginContainer/VBoxContainer/IngredientElement/Image/Icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shop_recipes_pressed() -> void:
	recipe_element.visible = true
	ingredient_element.visible = false


func _on_shop_ingredients_pressed() -> void:
	recipe_element.visible = false
	ingredient_element.visible = true

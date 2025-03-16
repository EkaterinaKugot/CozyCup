extends Control

@onready var recipe_image: TextureRect = $HBoxContainer/RecipeImage
@onready var name_recipe: Label = $HBoxContainer/MarginContainer/TextContainer/Name
@onready var description: Label = $HBoxContainer/MarginContainer/TextContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_book_recipes_change_recipe(recipe: Recipe) -> void:
	recipe_image.texture = load("res://assets/recipes/{0}.png".format([recipe.id]))
	name_recipe.text = recipe.name
	description.text = recipe.description


func _on_book_recipes_clear_recipe() -> void:
	recipe_image.texture = null
	name_recipe.text = ""
	description.text = ""

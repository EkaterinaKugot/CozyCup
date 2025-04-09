extends Control

@onready var name_ingredient: Label = $MarginContainer/VBoxContainer/Name
@onready var number: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Number

@onready var ingredient_image: TextureRect = $MarginContainer/VBoxContainer/IngredientImage
@onready var icon: TextureRect = $MarginContainer/VBoxContainer/IngredientImage/Icon

@onready var price: Label = $MarginContainer/VBoxContainer/HBoxContainer3/Price
@onready var number_purchase: Label = $MarginContainer/VBoxContainer/HBoxContainer/Panel/NumberPurchase

@onready var minus: Button = $MarginContainer/VBoxContainer/HBoxContainer/Minus
@onready var plus: Button = $MarginContainer/VBoxContainer/HBoxContainer/Plus

var ingredient: Ingredient
var min_size: Vector2 = Vector2(45, 45)

signal change_number_purchase(ingredient: Ingredient, number: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minus.pressed.connect(on_minus_pressed)
	plus.pressed.connect(on_plus_pressed)


func on_minus_pressed() -> void:
	var int_number_purchase = int(number_purchase.text)
	if int_number_purchase == 0:
		return
	int_number_purchase -= 1
	number_purchase.text = str(int_number_purchase)
	change_number_purchase.emit(ingredient, int(number_purchase.text))
	
func on_plus_pressed() -> void:
	var int_number_purchase = int(number_purchase.text)
	int_number_purchase += 1
	number_purchase.text = str(int_number_purchase)
	change_number_purchase.emit(ingredient, int(number_purchase.text))

func _on_purchase_clear_ingredients() -> void:
	ingredient = null
	name_ingredient.text = ""
	number.text = str(0)
	
	ingredient_image.texture = null
	icon.texture = null
	
	price.text = str(0)
	number_purchase.text = str(0)
	visible = false


func _on_purchase_ingredient_item_visible(
	ingredient1: Ingredient, 
	number_ing: int, 
	number_purchase1: int
) -> void:
	ingredient = ingredient1
	name_ingredient.text = ingredient1.name
	number.text = str(number_ing)
	
	if ingredient1.category == Ingredient.Category.SYRUP:
		ingredient_image.texture = load("res://assets/items/syrup.png")
		icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient1.id]))
		icon.custom_minimum_size = min_size
		icon.size = icon.custom_minimum_size
	elif ingredient1.category == Ingredient.Category.TOPPING:
		ingredient_image.texture = load("res://assets/items/topping_packet.png")
		icon.texture = load("res://assets/icons/{0}_icon.png".format([ingredient1.id]))
		icon.custom_minimum_size = min_size + Vector2(20, 20)
		icon.size = icon.custom_minimum_size
	else:
		ingredient_image.texture = load("res://assets/items/{0}.png".format([ingredient1.id]))
		icon.texture = null
	
	price.text = str(ingredient1.purchase_cost)
	number_purchase.text = str(number_purchase1)
	visible = true

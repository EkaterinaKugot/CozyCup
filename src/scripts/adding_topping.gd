extends Control

@onready var asset: TextureRect = $MarginContainer/Topping/Asset
@onready var number: Label = $MarginContainer/Topping/Number
var ingredient: Ingredient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ingredient = GameDay.coffe_cup.current_topping
	asset.texture = load("res://assets/icons/{0}_icon.png".format([ingredient.id]))
	if GameDay.coffe_cup.added_ingredients.size() != 0 and \
	GameDay.coffe_cup.added_ingredients[-1].keys()[0] == ingredient:
		number.text = str(GameDay.coffe_cup.added_ingredients[-1][ingredient])
	else:
		number.text = str(0)
	
func _on_drink_update_number() -> void:
	number.text = str(GameDay.coffe_cup.added_ingredients[-1][ingredient])

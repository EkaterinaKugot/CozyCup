extends Control

@onready var close: Button = $MarginContainer2/Close

@onready var next: Button = $MarginContainer/TabletHud/Next
@onready var back: Button = $MarginContainer/TabletHud/Back
@onready var buy: Button = $MarginContainer/TabletHud/Buy
@onready var amout: Label = $MarginContainer/TabletHud/AmountPurchase/Amout

@onready var ingredient_item1: Control = $MarginContainer/MarginContainer/HBoxContainer/Panel/IngredientItem
@onready var ingredient_item2: Control = $MarginContainer/MarginContainer/HBoxContainer/Panel2/IngredientItem
@onready var ingredient_item3: Control = $MarginContainer/MarginContainer/HBoxContainer/Panel3/IngredientItem

signal clear_ingredients
signal ingredient_item1_visible(ingredient: Ingredient, number: int, number_purchase: int)
signal ingredient_item2_visible(ingredient: Ingredient, number: int, number_purchase: int)
signal ingredient_item3_visible(ingredient: Ingredient, number: int, number_purchase: int)

var pages: Array[Dictionary]
var current_idx_page: int = 0
var opened_ingredients: Dictionary
const categories = [
	Ingredient.Category.GRAINS,
	Ingredient.Category.MILK,
	Ingredient.Category.CREAM,
	Ingredient.Category.SUGAR,
	Ingredient.Category.SYRUP,
	Ingredient.Category.TOPPING,
	Ingredient.Category.ICE_CREAM,
]

var basket: Dictionary
var money: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close.pressed.connect(on_close_pressed)
	back.pressed.connect(on_back_pressed)
	next.pressed.connect(on_next_pressed)
	buy.pressed.connect(on_buy_pressed)
	
	ingredient_item1.connect("change_number_purchase", change_number_purchase)
	ingredient_item2.connect("change_number_purchase", change_number_purchase)
	ingredient_item3.connect("change_number_purchase", change_number_purchase)
	
	opened_ingredients = Global.progress.opened_ingredients
	create_pages()
	fill_basket()
	fill_page()

func change_number_purchase(ingredient: Ingredient, number: int) -> void:
	basket[ingredient] = number
	money = 0
	for element in basket.keys():
		money += element.purchase_cost * basket[element]
		
	amout.text = str(money)

func on_buy_pressed() -> void:
	if not Global.progress.check_money(money): # проверяем, что хватает денег
		return

	Global.progress.sub_money(money)
	for ingredient in basket.keys():
		if basket[ingredient] > 0:
			Global.progress.add_number_ingredient(ingredient, basket[ingredient])
	
	opened_ingredients = Global.progress.opened_ingredients
	create_pages()
	fill_basket()
	fill_page()
	
	amout.text = str(0)
	
func on_close_pressed() -> void:
	GameDay.start_opening_stage()
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")

func create_pages() -> void:
	pages = []
	var page: Dictionary = {}
	var i: int = 0
	var key_ingredients = sort_ingredients(Array(opened_ingredients.keys()))
	for idx in range(key_ingredients.size()):
		if idx % 3 != 0:
			page[key_ingredients[idx]] = opened_ingredients[key_ingredients[idx]]
		else:
			page = {}
			page[key_ingredients[idx]] = opened_ingredients[key_ingredients[idx]]
		
		if idx % 3 == 2:
			pages.append(page)
		i = idx
		
	if i % 3 != 2:
		pages.append(page)

func sort_ingredients(ingredients: Array) -> Array:
	var result: Array = []
	
	for cat in categories:
		for ingredient in ingredients:
			if ingredient.category == cat:
				result.append(ingredient)
	return result

func fill_basket() -> void:
	for ingredient in opened_ingredients.keys():
		basket[ingredient] = 0
		
func fill_page() -> void:
	clear_ingredients.emit()
	for idx_page in range(pages.size()):
		if idx_page == current_idx_page:
			var keys = pages[idx_page].keys()
			for idx_ingredient in range(keys.size()):
				if idx_ingredient % 3 == 0:
					ingredient_item1_visible.emit(
						keys[idx_ingredient], 
						pages[idx_page][keys[idx_ingredient]],
						basket[keys[idx_ingredient]]
					)
				elif idx_ingredient % 3 == 1:
					ingredient_item2_visible.emit(
						keys[idx_ingredient], 
						pages[idx_page][keys[idx_ingredient]],
						basket[keys[idx_ingredient]]
					)
				else:
					ingredient_item3_visible.emit(
						keys[idx_ingredient],
						pages[idx_page][keys[idx_ingredient]],
						basket[keys[idx_ingredient]]
					)

func on_back_pressed() -> void:
	current_idx_page -= 1
	if current_idx_page < 0:
		current_idx_page = pages.size() - 1
	fill_page()
	
func on_next_pressed() -> void:
	current_idx_page += 1
	if current_idx_page == pages.size():
		current_idx_page = 0
	fill_page()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

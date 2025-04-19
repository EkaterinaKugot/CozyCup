extends Control

@onready var close: Button = $MarginContainer2/Close

@onready var recipes: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Recipes
@onready var ingredients: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Ingredients
@onready var improvements: CheckButton = $MarginContainer/HBoxContainer/Tabs/HBoxContainer/Improvements

@onready var recipe_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/RecipeContainer
@onready var ingredient_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/IngredientContainer
@onready var improvement_container: HBoxContainer = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/ImprovementContainer

@onready var all_opened: Label = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/AllOpened

@onready var back: Button = $MarginContainer/HBoxContainer/ShopItems/HBoxContainer/Back
@onready var next: Button = $MarginContainer/HBoxContainer/ShopItems/HBoxContainer/Next

@onready var shop_recipe1: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/RecipeContainer/Panel/ShopItem
@onready var shop_recipe2: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/RecipeContainer/Panel2/ShopItem

@onready var shop_ingredient1: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/IngredientContainer/Panel/ShopItem
@onready var shop_ingredient2: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/IngredientContainer/Panel2/ShopItem
@onready var shop_ingredient3: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/IngredientContainer/Panel3/ShopItem

@onready var shop_improvement1: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/ImprovementContainer/Panel/ShopItem
@onready var shop_improvement2: Control = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/ImprovementContainer/Panel2/ShopItem

@onready var name_tab: Label = $MarginContainer/HBoxContainer/ShopItems/MarginContainer/VBoxContainer/NameTab

signal recipes_pressed
signal ingredients_pressed
signal improvement_pressed

signal ingredient_item1_visible(ingredient: Ingredient)
signal ingredient_item2_visible(ingredient: Ingredient)
signal ingredient_item3_visible(ingredient: Ingredient)

signal recipe_item1_visible(recipe: Recipe)
signal recipe_item2_visible(recipe: Recipe)

signal improvement_item1_visible(improvement: Improvement)
signal improvement_item2_visible(improvement: Improvement)

signal clear_items

var pages_ingredients: Array[Array]
var current_page_ingredient: int = 0
var not_opened_ingredients: Array[Ingredient]
const number_ingredients: int = 3
const categories = [
	Ingredient.Category.GRAINS,
	Ingredient.Category.MILK,
	Ingredient.Category.CREAM,
	Ingredient.Category.SUGAR,
	Ingredient.Category.SYRUP,
	Ingredient.Category.TOPPING,
	Ingredient.Category.ICE_CREAM,
]

var pages_recipes: Array[Array]
var current_page_recipe: int = 0
var not_opened_recipes: Array[Recipe]
const number_recipes: int = 2

var pages_improvements: Array[Array]
var current_page_improvement: int = 0
var not_opened_improvements: Array[Improvement]
const number_improvements: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close.pressed.connect(on_close_pressed)
	
	recipes.pressed.connect(on_recipes_pressed)
	ingredients.pressed.connect(on_ingredients_pressed)
	improvements.pressed.connect(on_improvements_pressed)
	
	back.pressed.connect(on_back_pressed)
	next.pressed.connect(on_next_pressed)
	
	shop_recipe1.connect("open_item", open_item)
	shop_recipe2.connect("open_item", open_item)
	shop_ingredient1.connect("open_item", open_item)
	shop_ingredient2.connect("open_item", open_item)
	shop_ingredient3.connect("open_item", open_item)
	shop_improvement1.connect("open_item", open_item)
	shop_improvement2.connect("open_item", open_item)
	
	update_data()
	
	# вызываем для рецептов, так как она изначальная
	on_recipes_pressed(true)

func update_data() -> void:
	not_opened_ingredients = Global.select_not_opened_ingredients()
	not_opened_recipes = Global.select_not_opened_recipes()
	not_opened_improvements = Global.select_not_opened_improvements()
	
	pages_ingredients = create_pages(not_opened_ingredients, number_ingredients, true)
	pages_recipes = create_pages(not_opened_recipes, number_recipes)
	pages_improvements = create_pages(not_opened_improvements, number_improvements)
	
func create_pages(
	not_opened_items: Array, number_items: int, is_ingredients: bool = false
) -> Array[Array]:
	var pages: Array[Array] = []
	var page: Array = []
	var i: int = 0
	
	var sort_data: Array = not_opened_items
	if is_ingredients:
		sort_data = sort_ingredients(not_opened_items)
		
	for idx in range(sort_data.size()):
		if idx % number_items != 0:
			page.append(sort_data[idx])
		else:
			page = []
			page.append(sort_data[idx])
		
		if idx % number_items == number_items - 1:
			pages.append(page)
		i = idx
		
	if i % number_items != number_items - 1:
		pages.append(page)
		
	return pages
		
func sort_ingredients(ingredients: Array) -> Array:
	var result: Array = []
	
	for category in categories:
		for ingredient in ingredients:
			if ingredient.category == category:
				result.append(ingredient)
	return result

func fill_page(
	pages: Array[Array], current_idx_page: int, number_items: int, type_data
) -> void:
	clear_items.emit()
	for idx_page in range(pages.size()):
		if idx_page == current_idx_page:
			for idx_items in range(pages[idx_page].size()):
				var item = pages[idx_page][idx_items]
				if idx_items % number_items == number_items - 1:
					if type_data == Ingredient:
						ingredient_item3_visible.emit(item)
					elif type_data == Recipe:
						recipe_item2_visible.emit(item)
					else:
						improvement_item2_visible.emit(item)
				elif idx_items % number_items == number_items - 2:
					if type_data == Ingredient:
						ingredient_item2_visible.emit(item)
					elif type_data == Recipe:
						recipe_item1_visible.emit(item)
					else:
						improvement_item1_visible.emit(item)
				else:
					if type_data == Ingredient:
						ingredient_item1_visible.emit(item)

func open_item(item) -> void:
	if item in not_opened_recipes:
		Global.progress.sub_money(item.unlock_cost)
		Global.progress.add_new_opened_recipes(item)
		update_data()
		on_recipes_pressed(false)
	elif item in not_opened_ingredients:
		Global.progress.sub_money(item.unlock_cost)
		Global.progress.add_new_opened_ingredients(item)
		update_data()
		on_ingredients_pressed(false)
	elif item in not_opened_improvements:
		Global.progress.sub_diamonds(item.unlock_cost)
		Global.progress.add_new_improvement(item)
		update_data()
		on_improvements_pressed(false)
	
func on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")
	
func disabled_buttons() -> void:
	back.disabled = true
	next.disabled = true

func included_buttons() -> void:
	back.disabled = false
	next.disabled = false
	
func on_recipes_pressed(is_switched: bool = true) -> void:
	recipe_container.visible = true
	ingredient_container.visible = false
	improvement_container.visible = false
	name_tab.text = "Новые рецепты"
	recipes_pressed.emit()
	if not_opened_recipes.size() == 0:
		all_opened.visible = true
		recipe_container.visible = false
		clear_items.emit()
		disabled_buttons()
	else:
		all_opened.visible = false
		included_buttons()
		if is_switched:
			current_page_recipe = 0
		elif current_page_recipe == pages_recipes.size():
			current_page_recipe -= 1
		fill_page(pages_recipes, current_page_recipe, number_recipes, Recipe)
	
func on_ingredients_pressed(is_switched: bool = true) -> void:
	recipe_container.visible = false
	ingredient_container.visible = true
	improvement_container.visible = false
	name_tab.text = "Новые ингредиенты"
	ingredients_pressed.emit()
	if not_opened_ingredients.size() == 0:
		all_opened.visible = true
		ingredient_container.visible = false
		clear_items.emit()
		disabled_buttons()
	else:
		all_opened.visible = false
		included_buttons()
		if is_switched:
			current_page_ingredient = 0
		elif current_page_ingredient == pages_ingredients.size():
			current_page_ingredient -= 1
		fill_page(pages_ingredients, current_page_ingredient, number_ingredients, Ingredient)
	
func on_improvements_pressed(is_switched: bool = true) -> void:
	recipe_container.visible = false
	ingredient_container.visible = false
	improvement_container.visible = true
	name_tab.text = "Новые улучшения"
	improvement_pressed.emit()
	if not_opened_improvements.size() == 0:
		all_opened.visible = true
		improvement_container.visible = false
		clear_items.emit()
		disabled_buttons()
	else:
		all_opened.visible = false
		included_buttons()
		if is_switched:
			current_page_improvement = 0
		elif current_page_improvement == pages_improvements.size():
			current_page_improvement -= 1
		fill_page(pages_improvements, current_page_improvement, number_improvements, Improvement)

func on_back_pressed() -> void:
	if recipe_container.visible:
		current_page_recipe = leaf_back(current_page_recipe, pages_recipes)
		fill_page(pages_recipes, current_page_recipe, number_recipes, Recipe)
	elif ingredient_container.visible:
		current_page_ingredient = leaf_back(current_page_ingredient, pages_ingredients)
		fill_page(pages_ingredients, current_page_ingredient, number_ingredients, Ingredient)
	elif improvement_container.visible:
		current_page_improvement = leaf_back(current_page_improvement, pages_improvements)
		fill_page(pages_improvements, current_page_improvement, number_improvements, Improvement)

func leaf_back(current_page: int, pages: Array) -> int:
	current_page -= 1
	if current_page < 0:
			current_page = pages.size() - 1
	return current_page
	
func on_next_pressed() -> void:
	if recipe_container.visible:
		current_page_recipe = leaf_next(current_page_recipe, pages_recipes)
		fill_page(pages_recipes, current_page_recipe, number_recipes, Recipe)
	elif ingredient_container.visible:
		current_page_ingredient = leaf_next(current_page_ingredient, pages_ingredients)
		fill_page(pages_ingredients, current_page_ingredient, number_ingredients, Ingredient)
	elif improvement_container.visible:
		current_page_improvement = leaf_next(current_page_improvement, pages_improvements)
		fill_page(pages_improvements, current_page_improvement, number_improvements, Improvement)
		
func leaf_next(current_page: int, pages: Array) -> int:
	current_page += 1
	if current_page == pages.size():
			current_page = 0
	return current_page

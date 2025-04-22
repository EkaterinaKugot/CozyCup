extends Control

@onready var close: Button = $MarginContainer2/Close
@onready var back: Button = $MarginContainer/VBoxContainer/HBoxContainer/Page1/Panel2/Back
@onready var next: Button = $MarginContainer/VBoxContainer/HBoxContainer/Page2/Panel2/Next

@onready var recipe_item_left_top: Control = $MarginContainer/VBoxContainer/HBoxContainer/Page1/Panel/RecipeItem
@onready var recipe_item_left_bot: Control = $MarginContainer/VBoxContainer/HBoxContainer/Page1/Panel2/RecipeItem
@onready var recipe_item_right_top: Control = $MarginContainer/VBoxContainer/HBoxContainer/Page2/Panel/RecipeItem
@onready var recipe_item_right_bot: Control = $MarginContainer/VBoxContainer/HBoxContainer/Page2/Panel2/RecipeItem

signal left_top(recipe: Recipe)
signal left_bot(recipe: Recipe)
signal right_top(recipe: Recipe)
signal right_bot(recipe: Recipe)
signal clear_recipe

var opened_recipes: Array
var pages: Array[Array]
var current_idx_page: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	close.pressed.connect(on_close_pressed)
	back.pressed.connect(on_back_pressed)
	next.pressed.connect(on_next_pressed)
	
	opened_recipes = Global.progress.opened_recipes
	create_pages()
	fill_page()
	
func create_pages() -> void:
	var page: Array = []
	var i: int = 0
	for idx in range(opened_recipes.size()):
		if idx % 4 != 0:
			page.append(opened_recipes[idx])
		else:
			page = []
			page.append(opened_recipes[idx])
		
		if idx % 4 == 3:
			pages.append(page)
		i = idx
		
	if i % 4 != 3:
		pages.append(page)

func fill_page() -> void:
	clear_recipe.emit()
	for idx_page in range(pages.size()):
		if idx_page == current_idx_page:
			for idx_recipe in range(pages[idx_page].size()):
				if idx_recipe % 4 == 0:
					left_top.emit(pages[idx_page][idx_recipe])
				elif idx_recipe % 4 == 1:
					left_bot.emit(pages[idx_page][idx_recipe])
				elif idx_recipe % 4 == 2:
					right_top.emit(pages[idx_page][idx_recipe])
				else:
					right_bot.emit(pages[idx_page][idx_recipe])

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
	
func on_close_pressed() -> void:
	get_tree().paused = false
	var scene_back: String = GameDay.scenes[GameDay.current_scene]
	get_tree().change_scene_to_file(scene_back)

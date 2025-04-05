extends Control

@onready var continue_to_menu: Button = $MarginContainer/MarginContainer/VBoxContainer/Continue

@onready var number_client: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Clients/NumberClient

@onready var new_rating: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Rating/NewRating
@onready var diff_rating: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DiffRating

@onready var number_consumption: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Consumption/NumberConsumption
@onready var number_income: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Income/NumberIncome
@onready var number_profit: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Profit/NumberProfit

const good_color: Color = Color.FOREST_GREEN
const bad_color: Color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_to_menu.pressed.connect(on_continue_pressed)
	
	number_client.text = str(GameDay.statistic.served_clients) + "/" + str(GameDay.statistic.full_clients)

	new_rating.text = str(GameDay.statistic.new_rating)
	if GameDay.statistic.diff_rating >= 0:
		diff_rating.text = "+" + str(GameDay.statistic.diff_rating)
		diff_rating.add_theme_color_override("font_color", good_color)
	else:
		diff_rating.text = str(GameDay.statistic.diff_rating)
		diff_rating.add_theme_color_override("font_color", bad_color)
	
	number_consumption.text = str(GameDay.statistic.consumption)
	number_income.text = str(GameDay.statistic.income)
	if GameDay.statistic.profit >= 0:
		number_profit.text = "+" + str(GameDay.statistic.profit)
		number_profit.add_theme_color_override("font_color", good_color)
	else:
		number_profit.text = str(GameDay.statistic.profit)
		number_profit.add_theme_color_override("font_color", bad_color)
	
func on_continue_pressed() -> void:
	GameDay.start_menu_stage()
	get_tree().change_scene_to_file("res://src/scenes/menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

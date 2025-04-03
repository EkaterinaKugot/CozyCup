extends Control

@onready var start_new_day = $MarginFooter/Footer/Start as Button
@onready var shop: Button = $MarginFooter/Footer/Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_new_day.pressed.connect(on_start_pressed)
	shop.pressed.connect(on_shop_pressed)
	
func on_start_pressed() -> void:
	GameDay.start_purchase_stage()
	Global.save_progress()
	get_tree().change_scene_to_file("res://src/scenes/purchase.tscn")

func on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/shop.tscn")

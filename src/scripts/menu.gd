extends Control

@onready var start_new_day = $MarginFooter/Footer/Start as Button
@onready var shop: Button = $MarginFooter/Footer/Shop
@onready var info: Button = $MarginFooter/Footer/Info

var scene_info = preload("res://src/scenes/info.tscn")
var instance_info

var scene_training = preload("res://src/scenes/game_elements/training.tscn")
var instance_training

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_new_day.pressed.connect(on_start_pressed)
	shop.pressed.connect(on_shop_pressed)
	info.pressed.connect(on_info_pressed)
	
	if Global.progress.day == 1 and not GameDay.training_show:
		instance_training = scene_training.instantiate()
		instance_training.connect("ok_pressed", on_ok_training_pressed)
		get_tree().root.add_child.call_deferred(instance_training)
	
func on_start_pressed() -> void:
	GameDay.start_purchase_stage()
	Global.save_progress()
	get_tree().change_scene_to_file("res://src/scenes/purchase.tscn")

func on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/shop.tscn")
	
func on_info_pressed() -> void:
	instance_info = scene_info.instantiate()
	instance_info.connect("ok_pressed", on_ok_pressed)
		
	get_tree().root.add_child(instance_info)

func on_ok_pressed() -> void:
	if instance_info != null:
		instance_info.queue_free()
		
func on_ok_training_pressed() -> void:
	if instance_training  != null:
		instance_training .queue_free()
	GameDay.training_show = true
		

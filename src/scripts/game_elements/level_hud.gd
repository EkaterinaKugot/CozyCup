extends HBoxContainer

@onready var timer = $Timer
@onready var arrow = $Timer/Arrow

var total_time: float  # Общее время таймера в секундах
var current_time: float = 0.0 # Текущее время

var scene_confirmation_delete = preload("res://src/scenes/game_elements/action_confirmation.tscn")
var instance_confirmation_delete
var text_confirmation_delete = "Вы действительно хотите выкинуть напиток? Все использованные ингредиенты пропадут."
@onready var delete_coffee_cup: Button = $DeleteCoffeeCup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	delete_coffee_cup.pressed.connect(on_delete_coffee_cup_pressed)
	total_time = GameDay.client.order.lead_time
	timer.min_value = 0
	timer.max_value = total_time
	if GameDay.order_timer_is_start:
		current_time = GameDay.passed_time
	elif GameDay.client != null and GameDay.client.order.time_is_exceeded:
		current_time = total_time
	timer.value = current_time
	

func start_timer() -> void:
	total_time = GameDay.client.order.lead_time
	timer.max_value = total_time
	#timer_is_start = true
	
func on_delete_coffee_cup_pressed() -> void:
	instance_confirmation_delete = scene_confirmation_delete.instantiate()
	instance_confirmation_delete.connect("no_pressed", on_no_pressed)
	instance_confirmation_delete.connect("yes_pressed", on_yes_pressed)
	instance_confirmation_delete.get_node(
		"PanelContainer/MarginContainer/VBoxContainer/Text"
	).text = text_confirmation_delete
	get_tree().root.add_child(instance_confirmation_delete)
	
func on_no_pressed() -> void:
	if instance_confirmation_delete != null:
		instance_confirmation_delete.queue_free()
		
func on_yes_pressed() -> void:
	if instance_confirmation_delete != null:
		instance_confirmation_delete.queue_free()
	GameDay.coffe_cup.clean_coffee_cup()
	var coffee_cup = get_tree().current_scene.get_node("CoffeeCup")
	if get_tree().current_scene.name == "Level":
		coffee_cup = get_tree().current_scene.get_node("ControlCoffeeCup").get_node("CoffeeCup")
	if coffee_cup != null:
		coffee_cup.clean_added_instance()
		coffee_cup.display_ingredients()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameDay.order_timer_is_start:
		if current_time < total_time:
			current_time = GameDay.passed_time
			timer.value = current_time
			# Вращаем стрелку (360 градусов за total_time)
			arrow.rotation_degrees = (current_time / total_time) * 360
	elif current_time != 0:
		current_time = GameDay.passed_time
		timer.value = current_time
		arrow.rotation_degrees = 0

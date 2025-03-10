extends HBoxContainer

@onready var timer = $Timer
@onready var arrow = $Timer/Arrow

var total_time: float = 40.0  # Общее время таймера в секундах
var current_time: float = 0.0 # Текущее время
var timer_is_start: bool = false

var scene_confirmation_delete = preload("res://src/scenes/game_elements/confirmation_delete.tscn")
var instance_confirmation_delete
@onready var delete_coffee_cup: Button = $DeleteCoffeeCup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	timer.min_value = 0
	timer.max_value = total_time
	timer.value = current_time
	delete_coffee_cup.pressed.connect(on_delete_coffee_cup_pressed)

func on_delete_coffee_cup_pressed() -> void:
	instance_confirmation_delete = scene_confirmation_delete.instantiate()
	instance_confirmation_delete.connect("no_pressed", on_confirmation_delete_pressed)
	instance_confirmation_delete.connect("yes_pressed", on_confirmation_delete_pressed)
	get_tree().root.add_child(instance_confirmation_delete)
	
func on_confirmation_delete_pressed() -> void:
	if instance_confirmation_delete != null:
		instance_confirmation_delete.queue_free()
	var coffee_cup = get_tree().current_scene.get_node("CoffeeCup")
	print(coffee_cup)
	if coffee_cup != null:
		coffee_cup.clean_dict_instance()
		coffee_cup.display_ingredients()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_is_start:
		if current_time < total_time:
			# Увеличиваем текущее время
			current_time += delta
			timer.value = current_time
			# Вращаем стрелку (360 градусов за total_time)
			arrow.rotation_degrees = (current_time / total_time) * 360
		else:
			timer_is_start = false

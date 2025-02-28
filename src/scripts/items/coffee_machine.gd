extends Area2D

var scene_filling_water = preload("res://src/scenes/game_elements/filling_water.tscn")
var instance_filling_water = scene_filling_water.instantiate()
var start_mini_game: bool = false

@onready var coffee_machine = get_parent().coffee_machine

signal coffee_machine_pressed

func _process(_delta: float) -> void:
	if not start_mini_game and coffee_machine.number_water < coffee_machine.number_grains:
		start_mini_game = true
		get_parent().add_child(instance_filling_water)
		instance_filling_water.position = Vector2(250, 400)
		print(instance_filling_water.get_child(0).get_child(0).visible)
		instance_filling_water.get_child(0).connect("water_compartment_full", end_mini_game)

func end_mini_game() -> void:
	print(2)
	if instance_filling_water != null:
		instance_filling_water.queue_free()

	coffee_machine.number_water = 10
	start_mini_game = false
	
func _input_event(_viewport, event, _shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			print(event)
			emit_signal("coffee_machine_pressed")
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			emit_signal("coffee_machine_pressed")

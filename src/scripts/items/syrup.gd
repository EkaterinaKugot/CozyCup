extends "res://src/scripts/items/base_left_ingredient.gd"

var scene_adding_syrup = preload("res://src/scenes/game_elements/adding_syrup.tscn")
var instance_adding_syrup = scene_adding_syrup.instantiate()

func _input_event(_viewport, event, _shape_idx):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed :
			item_pressed = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			item_pressed = true
			
	if item_pressed:
		item_pressed = false
		glow_effect.visible = not glow_effect.visible
		ingredient_pressed.emit(ingredient)
		
		if glow_effect.visible and \
		Global.progress.check_number_ingredient(ingredient, 1):
			start_mini_game()
		if not glow_effect.visible:
			delete_mini_game()
		
func start_mini_game() -> void:
	get_parent().add_child(instance_adding_syrup)
	instance_adding_syrup.position = get_parent().get_node("CoffeeCup").position - Vector2(160, 100)
	instance_adding_syrup.get_node("DraggableButton").connect("mini_game_end", mini_game_end)

func mini_game_end() -> void:
	get_parent().get_node("CoffeeCup").add_ingredient(ingredient)

func delete_mini_game() -> void:
	if instance_adding_syrup != null:
		instance_adding_syrup.queue_free()
	
	instance_adding_syrup = scene_adding_syrup.instantiate()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

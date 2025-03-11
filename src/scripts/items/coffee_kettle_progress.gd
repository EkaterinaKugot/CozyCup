extends TextureProgressBar

var is_holding: bool = false
var hold_time: float = 0.0
var max_hold_time: float 
var max_number_coffee: int = GameDay.coffee_machine.max_number_elements

var add_grains_shape
var start_coffee_shape

signal undisabled_bottom_hud()

func _ready() -> void:
	min_value = 0
	max_value = max_number_coffee
	value = 0
	
	add_grains_shape = $"../../AddGrainsShape"
	start_coffee_shape = $"../../StartCoffeeShape"
	
	add_grains_shape.disabled = false
	start_coffee_shape.disabled = false
	
	if GameDay.coffee_machine.coffee_is_ready:
		value = max_number_coffee
		get_parent().visible = true
		$"../CoffeeKettle".z_index = 1

func start_progress() -> void:
	get_parent().visible = true
	$"../CoffeeKettle".z_index = 1
	max_hold_time = GameDay.coffee_machine.number_grains * 2
	
	start_coffee_shape.disabled = true
	add_grains_shape.disabled = true
	
	is_holding = true
	
func _process(delta):
	if is_holding:
		hold_time += delta
		value = (hold_time / max_hold_time) * max_number_coffee
		if hold_time >= max_hold_time:
			is_holding = false
			hold_time = 0.0
			add_grains_shape.disabled = false
			start_coffee_shape.disabled = false
			
			GameDay.coffee_machine.сooking_coffee()
			GameDay.coffee_machine.use_elements()
			$"../..".update_label_grains_container()
			
			undisabled_bottom_hud.emit()
			

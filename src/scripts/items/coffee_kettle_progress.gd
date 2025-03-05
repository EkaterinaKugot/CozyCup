extends TextureProgressBar

var is_holding: bool = false
var hold_time: float = 0.0
var max_hold_time: float 
var max_number_coffee: int = 10

func _ready() -> void:
	min_value = 0
	max_value = max_number_coffee
	value = 0
	
	$"../../AddGrainsShape".disabled = false
	$"../../StartCoffeeShape".disabled = false
	
	if CoffeeMachine.coffee_is_ready == true:
		value = max_number_coffee
		get_parent().visible = true
		$"../CoffeeKettle".z_index = 1

func start_progress() -> void:
	get_parent().visible = true
	$"../CoffeeKettle".z_index = 1
	max_hold_time = CoffeeMachine.number_grains * 2
	
	$"../../StartCoffeeShape".disabled = true
	$"../../AddGrainsShape".disabled = true
	
	is_holding = true
	
func _process(delta):
	if is_holding:
		hold_time += delta
		value = (hold_time / max_hold_time) * max_number_coffee
		if hold_time >= max_hold_time:
			is_holding = false
			hold_time = 0.0
			$"../../AddGrainsShape".disabled = false
			$"../../StartCoffeeShape".disabled = false
			
			CoffeeMachine.сooking_coffee()
			CoffeeMachine.use_elements()
			$"../..".update_label_grains_container()

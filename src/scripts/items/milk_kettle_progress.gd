extends TextureProgressBar

var is_holding: bool = false
var hold_time: float = 0.0
var max_hold_time: float 
var max_number_milk: int = GameDay.milk_frother.max_number_elements

var add_milk_shape
var start_milk_shape

signal undisabled_bottom_hud()

func _ready() -> void:
	min_value = 0
	max_value = max_number_milk
	value = 0
	
	add_milk_shape = $"../../AddMilkShape"
	start_milk_shape = $"../../StartMilkShape"
	
	add_milk_shape.disabled = false
	start_milk_shape.disabled = false
	
	if GameDay.milk_frother.milk_is_ready:
		value = max_number_milk
		get_parent().visible = true
		$"../MilkKettle".z_index = 1

func start_progress() -> void:
	get_parent().visible = true
	$"../MilkKettle".z_index = 1
	max_hold_time = GameDay.milk_frother.number_milk * 2
	
	start_milk_shape.disabled = true
	add_milk_shape.disabled = true
	
	is_holding = true
	
func _process(delta):
	if is_holding:
		hold_time += delta
		value = (hold_time / max_hold_time) * max_number_milk
		if hold_time >= max_hold_time:
			is_holding = false
			hold_time = 0.0
			add_milk_shape.disabled = false
			start_milk_shape.disabled = false
			
			GameDay.milk_frother.сooking_milk()
			GameDay.milk_frother.use_elements()
			$"../..".update_label_milk_container()
			
			undisabled_bottom_hud.emit()

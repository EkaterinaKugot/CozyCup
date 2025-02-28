extends TextureProgressBar

signal water_compartment_full

var is_holding: bool = false
var hold_time: float = 0.0
var max_hold_time: float = 3.0 
var max_number_water: int = 10

func _ready() -> void:
	min_value = 0
	max_value = max_number_water
	value = 0

func _gui_input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			is_holding = true
			#print($GlowEffect.visible)
			$GlowEffect.visible = true
		else:
			is_holding = false
			$GlowEffect.visible = false

func _process(delta):
	if is_holding:
		hold_time += delta
		value = (hold_time / max_hold_time) * max_number_water
		if hold_time >= max_hold_time:
			is_holding = false
			print(1)
			emit_signal("water_compartment_full")
			# Здесь можно добавить действие при полном заполнении

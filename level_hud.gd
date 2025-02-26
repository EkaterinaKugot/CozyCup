extends HBoxContainer

@onready var timer = $Timer
@onready var arrow = $Timer/Arrow

var total_time: float = 40.0  # Общее время таймера в секундах
var current_time: float = 0.0 # Текущее время
var timer_is_start: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	timer.min_value = 0
	timer.max_value = total_time
	timer.value = current_time

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

extends Button

var dragging = false
var initial_mouse_y: float
var max_y: float
var min_y: float
var initial_button_y: float

signal mini_game_end

func _gui_input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or \
	event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			initial_mouse_y = get_global_mouse_position().y
			initial_button_y = position.y
		else:
			dragging = false
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and dragging:
		var current_mouse_y = get_global_mouse_position().y
		var delta_y = current_mouse_y - initial_mouse_y
		var new_y = initial_button_y + delta_y
		new_y = clamp(new_y, min_y, max_y)
		
		position.y = new_y
		
		# Обновляем значение TextureProgressBar
		var progress = new_y / max_y
		var texture_progress = get_node("../TextureProgressBar")
		texture_progress.value = progress * texture_progress.max_value
		
		# Проверяем, достигла ли кнопка низа
		if new_y >= max_y:
			dragging = false
			mini_game_end.emit()
			
			get_node("../TextureProgressBar").value = 0
			position.y = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../TextureProgressBar").value = 0
	position.y = 0
	max_y = get_parent().size.y - size.y
	min_y = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

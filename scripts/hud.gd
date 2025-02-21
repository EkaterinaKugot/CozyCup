extends CanvasLayer

@onready var drop_menu = $HeaderControl/MarginContainer/Header/DropMenu as Button
@onready var elements_menu = $DroppingMenu
@onready var animation_elements_menu = $AnimationPlayer

func _ready() -> void:
	drop_menu.pressed.connect(on_drop_menu_pressed)
	
func on_drop_menu_pressed() -> void:
	if elements_menu.visible:
		animation_elements_menu.play("fade_out_elements_menu")
		await animation_elements_menu.animation_finished
		
		elements_menu.visible = false
		elements_menu.set_process(false)
	else:
		elements_menu.visible = true
		animation_elements_menu.play("fade_in_elements_menu")
		elements_menu.set_process(true)

func _process(delta: float) -> void:
	pass

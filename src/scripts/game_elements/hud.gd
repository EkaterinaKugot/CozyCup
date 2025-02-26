extends CanvasLayer

@onready var drop_menu = $HeaderControl/MarginRight/Header/DropMenu as Button
@onready var elements_menu = $DroppingMenu
@onready var animation_elements_menu = $AnimationPlayer

@onready var level_hud = $HeaderControl/MarginLeft/HBoxContainer/LevelHud

@onready var label_day = $HeaderControl/MarginLeft/HBoxContainer/DateTimePanel/TextContainer/Day as Label
@onready var label_time = $HeaderControl/MarginLeft/HBoxContainer/DateTimePanel/TextContainer/Time as Label
@onready var label_rating = $HeaderControl/MarginLeft/HBoxContainer/RatingPanel/TextPanel/Number as Label
@onready var label_money = $HeaderControl/MarginRight/Header/MoneyPanel/TextPanel/Money as Label
@onready var label_diamonds = $HeaderControl/MarginRight/Header/DiamondPanel/TextPanel/Diamonds as Label


func _ready() -> void:
	drop_menu.pressed.connect(on_drop_menu_pressed)
	
	label_day.text = str(Global.progress.day) + " день"
	label_time.text = str(
		Global.progress.option_duration_day[Global.progress.duration_day][0]
		) + ":00"
	if fmod(Global.progress.rating, 1) == 0:
		label_rating.text = str(Global.progress.rating) + ".0"
	else:
		label_rating.text = str(Global.progress.rating)
	
	label_money.text = str(Global.progress.money)
	label_diamonds.text = str(Global.progress.diamonds)
	
	
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


func _on_level_leve_hud_visible() -> void:
	level_hud.visible = true
	level_hud.set_process(true)


func _on_menu_leve_hud_invisible() -> void:
	level_hud.visible = false
	level_hud.set_process(false)

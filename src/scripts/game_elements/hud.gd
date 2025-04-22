extends CanvasLayer

@onready var drop_menu = $HeaderControl/MarginRight/Header/DropMenu as Button
@onready var elements_menu = $DroppingMenu
@onready var animation_elements_menu = $AnimationPlayer

@onready var level_hud = $HeaderControl/MarginLeft/VBoxContainer/HBoxContainer/LevelHud
@onready var order_repeat: Control = $OrderRepeat

@onready var label_day: Label = $HeaderControl/MarginLeft/VBoxContainer/HBoxContainer/DateTimePanel/TextContainer/Day
@onready var label_time: Label = $HeaderControl/MarginLeft/VBoxContainer/HBoxContainer/DateTimePanel/TextContainer/Time
@onready var label_rating: Label = $HeaderControl/MarginLeft/VBoxContainer/HBoxContainer/RatingPanel/TextPanel/Number

@onready var open_cafe: Button = $HeaderControl/MarginLeft/VBoxContainer/OpenClose/MarginContainer/Open
@onready var close_cafe: Button = $HeaderControl/MarginLeft/VBoxContainer/OpenClose/MarginContainer/Close

@onready var label_money: Label = $HeaderControl/MarginRight/Header/VBoxContainer/MoneyPanel/TextPanel/Money
@onready var changing_money: Label = $HeaderControl/MarginRight/Header/VBoxContainer/ChangingMoney

@onready var changing_diamonds: Label = $HeaderControl/MarginRight/Header/VBoxContainer2/ChangingDiamonds

@onready var daily_tasks: Button = $HeaderControl/MarginRight/Header/VBoxContainer2/DiamondPanel/DailyTasks
@onready var diamonds_container: VBoxContainer = $HeaderControl/MarginRight/Header/VBoxContainer2

var scene_daily_tasks = preload("res://src/scenes/game_elements/daily_tasks.tscn")
var instance_daily_tasks

const good_color: Color = Color.FOREST_GREEN
const bad_color: Color = Color.RED

func _ready() -> void:
	drop_menu.pressed.connect(on_drop_menu_pressed)
	
	open_cafe.pressed.connect(on_open_cafe_pressed)
	close_cafe.pressed.connect(on_close_cafe_pressed)
	daily_tasks.pressed.connect(on_daily_tasks_pressed)
	
	if GameDay.stages_game.current_stage == StagesGame.Stage.MENU or \
	GameDay.stages_game.current_stage == StagesGame.Stage.PURCHASE:
		level_hud.visible = false
		level_hud.set_process(false) 
		label_time.text = str(
			Global.progress.option_duration_day[Global.progress.duration_day][0]
		) + ":00"
	else:
		level_hud.visible = true
		level_hud.set_process(true) 
	
	if GameDay.stages_game.current_stage == StagesGame.Stage.STATISTIC:
		level_hud.visible = false
		level_hud.set_process(false) 
		label_time.text = str(
			Global.progress.option_duration_day[Global.progress.duration_day][1]
		) + ":00"
		
	if GameDay.stages_game.current_stage == StagesGame.Stage.OPENING:
		open_cafe.visible = true
		label_time.text = str(
			Global.progress.option_duration_day[Global.progress.duration_day][0]
		) + ":00"
	
	label_day.text = str(Global.progress.day) + " день"
	if fmod(Global.progress.rating, 1) == 0:
		label_rating.text = str(Global.progress.rating) + ".0"
	else:
		label_rating.text = str(Global.progress.rating)
		
	label_money.text = str(Global.progress.money)
	
	Global.progress.daily_tasks.check_and_update_tasks()

func _process(_delta: float) -> void:
	#print("FPS " + str(Engine.get_frames_per_second()))
	if GameDay.stages_game.current_stage == StagesGame.Stage.CLOSING:
		close_cafe.visible = true
		label_time.text = str(
			Global.progress.option_duration_day[Global.progress.duration_day][1]
		) + ":00"
	elif GameDay.stages_game.current_stage == StagesGame.Stage.GAME:
		var hours: int = int(GameDay.passed_seconds_in_day * 2) / 60
		var minutes: int = int(GameDay.passed_seconds_in_day * 2) - (hours * 60)
		label_time.text = str(
			Global.progress.option_duration_day[Global.progress.duration_day][0] + hours
			) + ":" + str(
				(minutes / Global.progress.size_intervals) * Global.progress.size_intervals
			)
		if minutes / Global.progress.size_intervals == 0:
			label_time.text += "0"
			
	if GameDay.stages_game.current_stage != StagesGame.Stage.OPENING and \
	GameDay.stages_game.current_stage != StagesGame.Stage.STATISTIC:
		label_money.text = str(Global.progress.money)
	
func on_daily_tasks_pressed() -> void:
	if instance_daily_tasks != null:
		instance_daily_tasks.queue_free()
		get_tree().paused = false
		
		if elements_menu.instance_settings != null or get_parent().instance_info != null:
			get_tree().paused = true
	else:
		instance_daily_tasks = scene_daily_tasks.instantiate()
		instance_daily_tasks.connect("ok_pressed", on_ok_pressed)
		
		Global.progress.daily_tasks.check_and_update_tasks()
		get_tree().root.add_child(instance_daily_tasks)

func on_ok_pressed() -> void:
	if instance_daily_tasks != null:
		instance_daily_tasks.queue_free()
	
	if elements_menu.instance_settings != null or \
	(get_tree().current_scene.name == "Menu" and get_parent().instance_info != null):
		get_tree().paused = true
		
func on_open_cafe_pressed() -> void:
	GameDay.start_game_stage()
	open_cafe.visible = false

func on_close_cafe_pressed() -> void:
	GameDay.end_closing_stage()
	close_cafe.visible = false
	Global.save_progress()
	get_tree().change_scene_to_file("res://src/scenes/statistic.tscn") # На сцену статистики
	
	
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

func show_changing_money(number_money: int, is_positive: bool = true) -> void:
	if is_positive:
		changing_money.text = "+"
		changing_money.add_theme_color_override("font_color", good_color)
	else:
		changing_money.text = "-"
		changing_money.add_theme_color_override("font_color", bad_color)
	changing_money.text += str(abs(number_money))
	
	changing_money.visible = true
	animation_elements_menu.play("fade_in_money")
	await animation_elements_menu.animation_finished
	
	animation_elements_menu.play("fade_out_money")
	await animation_elements_menu.animation_finished
	changing_money.visible = false
	
func _on_level_hud_order_repeat_pressed() -> void:
	if level_hud.visible:
		if GameDay.client.order_accept:
			order_repeat.visible = not order_repeat.visible
		elif GameDay.client_is_waiting:
			order_repeat.visible = false
			
		if order_repeat.visible:
			order_repeat.get_node("PanelContainer/MarginContainer/Label").text = GameDay.client.order.text

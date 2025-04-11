extends Control

@onready var task_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task
@onready var task_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task2
@onready var task_3: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task3

@onready var ok: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Ok

@onready var ads: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/Ads
@onready var number_ads: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/NumberAds

signal clear_all
signal fill_task_1(idx: int)
signal fill_task_2(idx: int)
signal fill_task_3(idx: int)
signal ok_pressed

func _ready() -> void:
	get_tree().paused = true
	ok.pressed.connect(on_ok_pressed)
	fill_task()
	
	if Global.progress.daily_tasks.current_number_ads == 0:
		ads.disabled = true
	else:
		ads.disabled = false
	update_number_ads()

func update_number_ads() -> void:
	number_ads.text = str(Global.progress.daily_tasks.current_number_ads) + " x"
	
func on_ok_pressed() -> void:
	get_tree().paused = false
	ok_pressed.emit()
	
func fill_task() -> void:
	clear_all.emit()
	fill_task_1.emit(1)
	fill_task_2.emit(2)
	fill_task_3.emit(3)
	
func _process(_delta: float) -> void:
	pass

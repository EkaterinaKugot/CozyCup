extends Control

@onready var task_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task
@onready var task_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task2
@onready var task_3: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task3

@onready var ok: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Ok

signal clear_all
signal fill_task_1(task_dict: Dictionary)
signal fill_task_2(task_dict: Dictionary)
signal fill_task_3(task_dict: Dictionary)
signal ok_pressed

func _ready() -> void:
	get_tree().paused = true
	ok.pressed.connect(on_ok_pressed)
	fill_task()

func on_ok_pressed() -> void:
	get_tree().paused = false
	ok_pressed.emit()
	
func fill_task() -> void:
	clear_all.emit()
	fill_task_1.emit(Global.progress.daily_tasks.active_tasks[1])
	fill_task_2.emit(Global.progress.daily_tasks.active_tasks[2])
	fill_task_3.emit(Global.progress.daily_tasks.active_tasks[3])
	

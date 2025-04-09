extends Control

@onready var task_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task
@onready var task_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task2
@onready var task_3: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task3

@onready var ok: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Ok

signal clear_all
signal fill_task_1(idx: int)
signal fill_task_2(idx: int)
signal fill_task_3(idx: int)
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
	fill_task_1.emit(1)
	fill_task_2.emit(2)
	fill_task_3.emit(3)
	

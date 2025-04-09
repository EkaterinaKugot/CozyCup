extends PanelContainer

@onready var conditions: Label = $HBoxContainer/Conditions/VBoxContainer/Conditions
@onready var progress: Label = $HBoxContainer/Conditions/VBoxContainer/PanelContainer/Progress

@onready var number_reward: Label = $HBoxContainer/Reward/Number

@onready var in_progress: Label = $HBoxContainer/Status/MarginContainer/InProgress
@onready var accept: Button = $HBoxContainer/Status/MarginContainer/Accept
@onready var performed: TextureRect = $HBoxContainer/Status/MarginContainer/Performed

var task: DailyTask
var idx_task: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	accept.pressed.connect(on_accept_pressed)
	change_status_in_progress()

func on_accept_pressed() -> void:
	change_status_performed()
	Global.progress.daily_tasks.change_status_to_perfomed(idx_task)
	Global.progress.add_diamonds(task.reward)
	get_tree().current_scene.get_node("Hud").get_script().update_diamonds()
	
func change_status_in_progress() -> void:
	in_progress.visible = true
	accept.visible = false
	performed.visible = false
	
func change_status_accept() -> void:
	in_progress.visible = false
	accept.visible = true
	performed.visible = false
	
func change_status_performed() -> void:
	in_progress.visible = false
	accept.visible = false
	performed.visible = true
	
func _on_daily_tasks_clear_all() -> void:
	conditions.text = ""
	progress.text = ""
	number_reward.text = ""
	change_status_in_progress()

func _on_daily_tasks_fill_task(idx: int) -> void:
	idx_task = idx
	var task_dict = Global.progress.daily_tasks.active_tasks[idx]
	task = task_dict.keys()[0]
	
	conditions.text = task.task_text
	progress.text = str(task_dict[task]["current_progress"]) + "/" + str(task.target_value)
	number_reward.text = str(task.reward)
	
	if task_dict[task]["status"] == DailyTasksManager.TaskStatus.ACCEPT:
		change_status_accept()
	elif task_dict[task]["status"] == DailyTasksManager.TaskStatus.PERFOMED:
		change_status_performed()
	else:
		change_status_in_progress()

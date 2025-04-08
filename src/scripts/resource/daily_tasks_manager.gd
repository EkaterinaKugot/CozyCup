extends Resource
class_name DailyTasksManager

enum TaskStatus { 
	IN_PROGRESS, 
	ACCEPT, 
	PERFOMED 
}

@export var tasks: Dictionary = {
	1: [preload("res://data/daily_tasks/entrance.tres")],
	2: [
		preload("res://data/daily_tasks/americano.tres"),
		preload("res://data/daily_tasks/breve.tres"),
		preload("res://data/daily_tasks/cappuccino.tres"),
		preload("res://data/daily_tasks/doppio.tres"),
		preload("res://data/daily_tasks/espressino.tres"),
		preload("res://data/daily_tasks/espresso.tres"),
		preload("res://data/daily_tasks/flat_white.tres"),
		preload("res://data/daily_tasks/glace.tres"),
		preload("res://data/daily_tasks/latte.tres"),
		preload("res://data/daily_tasks/moccachino.tres"),
		preload("res://data/daily_tasks/piccolo.tres"),
		preload("res://data/daily_tasks/raf.tres"),
		preload("res://data/daily_tasks/triple.tres")
	],
	3: [
		preload("res://data/daily_tasks/consumption.tres"), 
		preload("res://data/daily_tasks/income.tres"),
		preload("res://data/daily_tasks/serving.tres")
	]  
} # Словарь с всеми DailyTask

@export var active_tasks: Dictionary = {}
@export var last_update_unix: int = 0

func check_need_accept() -> bool:
	for task in active_tasks.values():
		if task.values()[0]["status"] == TaskStatus.ACCEPT:
			return true
	return false

func generate_daily_tasks() -> void:
	active_tasks.clear()
	for i in tasks.keys():
		var task
		if i == 2:
			var recipe = Global.progress.opened_recipes.pick_random()
			for t in tasks[i]:
				if t.recipe == recipe:
					task = t
					break
		else:
			task = tasks[i].pick_random()
		active_tasks[i] = {task: {"current_progress": 0, "status": TaskStatus.IN_PROGRESS}}
	
func check_and_update_tasks() -> void:
	var current_time = Time.get_datetime_dict_from_system()
	var current_unix = Time.get_unix_time_from_datetime_dict(current_time)
	
	var next_update_dict = {
		"year": current_time["year"],
		"month": current_time["month"],
		"day": current_time["day"],
		"hour": 12,
		"minute": 0,
		"second": 0
	}
	var next_update_unix = Time.get_unix_time_from_datetime_dict(next_update_dict)
	
	if current_unix < next_update_unix:
		next_update_unix -= 24 * 60 * 60  # Минус сутки
	
	if current_unix >= next_update_unix and last_update_unix < next_update_unix:
		last_update_unix = next_update_unix
		generate_daily_tasks()

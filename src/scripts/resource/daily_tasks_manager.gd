extends Resource
class_name DailyTasks

enum TaskStatus { 
	IN_PROGRESS, 
	ACCEPT, 
	PERFOMED 
}

@export var tasks: Dictionary = {
	1: [load("res://data/daily_tasks/entrance.tres")],
	2: [
		load("res://data/daily_tasks/americano.tres"),
		load("res://data/daily_tasks/breve.tres"),
		load("res://data/daily_tasks/cappuccino.tres"),
		load("res://data/daily_tasks/doppio.tres"),
		load("res://data/daily_tasks/espressino.tres"),
		load("res://data/daily_tasks/espresso.tres"),
		load("res://data/daily_tasks/flat_white.tres"),
		load("res://data/daily_tasks/glace.tres"),
		load("res://data/daily_tasks/latte.tres"),
		load("res://data/daily_tasks/moccachino.tres"),
		load("res://data/daily_tasks/piccolo.tres"),
		load("res://data/daily_tasks/raf.tres"),
		load("res://data/daily_tasks/triple.tres")
	],
	3: [
		load("res://data/daily_tasks/consumption.tres"), 
		load("res://data/daily_tasks/income.tres"),
		load("res://data/daily_tasks/serving.tres")
	]  
} # Словарь со всеми DailyTask

@export var active_tasks: Dictionary = {}
@export var last_update_unix: int = 0

@export var current_number_ads: int = 10
@export var max_number_ads: int = 10

func sub_ads() -> void:
	if current_number_ads != 0:
		current_number_ads -= 1
		
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
	
	current_number_ads = max_number_ads
	
func update_progress(idx: int, value: int) -> void:
	if get_status(idx) == TaskStatus.IN_PROGRESS:
		active_tasks[idx].values()[0]["current_progress"] = clamp(
			active_tasks[idx].values()[0]["current_progress"] + value, 0,  get_task(idx).target_value
		)
		_change_status_to_accept(idx)

func _change_status_to_accept(idx: int) -> void:
	if active_tasks[idx].values()[0][
		"current_progress"
		] >= get_task(idx).target_value:
		active_tasks[idx].values()[0]["status"] = TaskStatus.ACCEPT

func change_status_to_perfomed(idx: int) -> void:
	active_tasks[idx].values()[0]["status"] = TaskStatus.PERFOMED

func get_status(idx: int) -> TaskStatus:
	return active_tasks[idx].values()[0]["status"]
	
func get_task(idx: int) -> DailyTask:
	return active_tasks[idx].keys()[0]
	
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

extends Resource
class_name DailyTask

@export var id: String = "" 		   # ID
@export var task_text: String = ""     # Текст задания
@export var reward: int = 0            # Награда
@export var target_value: int = 0      # Целевое значение
@export var recipe: Recipe

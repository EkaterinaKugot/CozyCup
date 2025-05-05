extends Resource
class_name Settings

@export var music: int = 5:
	get:
		return music
	set(value):
		if value >= 0 and value <= 10:
			music = value	
@export var sounds: int = 7:
	get:
		return sounds
	set(value):
		if value >= 0 and value <= 10:
			sounds = value


func change_music(value: int) -> void:
	music = value
	
func change_sounds(value: int) -> void:
	sounds = value

extends Resource
class_name Settings

@export var music: int = 5:
	get:
		return music
	set(value):
		assert(value >= 0 and value <= 10, "The value of music should be from 0 to 10")
		music = value	
@export var sounds: int = 7:
	get:
		return sounds
	set(value):
		assert(value >= 0 and value <= 10, "The value of sounds should be from 0 to 10")
		sounds = value


func change_music(value: int) -> void:
	music = value
	
func change_sounds(value: int) -> void:
	sounds = value

extends GutTest

var settings_instance = null

func before_each():
	settings_instance = Settings.new()

func after_each():
	settings_instance = null

func test_music_property():
	# Проверка начального значения
	assert_eq(settings_instance.music, 5, "Начальное значение music должно быть 5")
	
	# Проверка корректного значения
	settings_instance.music = 8
	assert_eq(settings_instance.music, 8, "music должно быть равно 8 после установки")
	
	# Проверка границы min (0)
	settings_instance.music = 0
	assert_eq(settings_instance.music, 0, "music должно быть равно 0 на нижней границе")
	
	# Проверка границы max (10)
	settings_instance.music = 10
	assert_eq(settings_instance.music, 10, "music должно быть равно 10 на верхней границе")
	
	# Проверка некорректных значений
	var old_music = settings_instance.music
	settings_instance.music = -1
	assert_eq(settings_instance.music, old_music, "music не должно измениться при значении меньше 0")
	
	settings_instance.music = 11
	assert_eq(settings_instance.music, old_music, "music не должно измениться при значении больше 10")

func test_sounds_property():
	# Проверка начального значения
	assert_eq(settings_instance.sounds, 7, "Начальное значение sounds должно быть 7")
	
	# Проверка корректного значения
	settings_instance.sounds = 3
	assert_eq(settings_instance.sounds, 3, "sounds должно быть равно 3 после установки")
	
	# Проверка границы min (0)
	settings_instance.sounds = 0
	assert_eq(settings_instance.sounds, 0, "sounds должно быть равно 0 на нижней границе")
	
	# Проверка границы max (10)
	settings_instance.sounds = 10
	assert_eq(settings_instance.sounds, 10, "sounds должно быть равно 10 на верхней границе")
	
	# Проверка некорректных значений
	var old_sounds = settings_instance.sounds
	settings_instance.sounds = -1
	assert_eq(settings_instance.sounds, old_sounds, "sounds не должно измениться при значении меньше 0")
	
	settings_instance.sounds = 11
	assert_eq(settings_instance.sounds, old_sounds, "sounds не должно измениться при значении больше 10")

func test_change_music():
	# Проверка изменения через метод
	settings_instance.change_music(6)
	assert_eq(settings_instance.music, 6, "change_music должно установить music в 6")
	
	# Проверка границы min
	settings_instance.change_music(0)
	assert_eq(settings_instance.music, 0, "change_music должно установить music в 0")
	
	# Проверка границы max
	settings_instance.change_music(10)
	assert_eq(settings_instance.music, 10, "change_music должно установить music в 10")
	
	# Проверка некорректных значений
	var old_music = settings_instance.music
	settings_instance.change_music(-1)
	assert_eq(settings_instance.music, old_music, "change_music не должно изменять music при значении меньше 0")
	
	settings_instance.change_music(11)
	assert_eq(settings_instance.music, old_music, "change_music не должно изменять music при значении больше 10")

func test_change_sounds():
	# Проверка изменения через метод
	settings_instance.change_sounds(4)
	assert_eq(settings_instance.sounds, 4, "change_sounds должно установить sounds в 4")
	
	# Проверка границы min
	settings_instance.change_sounds(0)
	assert_eq(settings_instance.sounds, 0, "change_sounds должно установить sounds в 0")
	
	# Проверка границы max
	settings_instance.change_sounds(10)
	assert_eq(settings_instance.sounds, 10, "change_sounds должно установить sounds в 10")
	
	# Проверка некорректных значений
	var old_sounds = settings_instance.sounds
	settings_instance.change_sounds(-1)
	assert_eq(settings_instance.sounds, old_sounds, "change_sounds не должно изменять sounds при значении меньше 0")
	
	settings_instance.change_sounds(11)
	assert_eq(settings_instance.sounds, old_sounds, "change_sounds не должно изменять sounds при значении больше 10")

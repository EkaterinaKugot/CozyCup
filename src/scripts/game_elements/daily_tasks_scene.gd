extends Control

@onready var task_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task
@onready var task_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task2
@onready var task_3: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task3

@onready var ok: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Ok

@onready var reward_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/Ads
@onready var number_ads: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/NumberAds

@onready var yandex_ads: YandexAds = $YandexAds

var is_waiting_for_reward = false

signal clear_all
signal fill_task_1(idx: int)
signal fill_task_2(idx: int)
signal fill_task_3(idx: int)
signal ok_pressed

func _ready() -> void:
	get_tree().paused = true
	ok.pressed.connect(on_ok_pressed)
	fill_task()
	
	reward_button.pressed.connect(_on_reward_button_pressed)
	update_number_ads()
	
	if yandex_ads:
		# Подключаем сигналы YandexAds
		yandex_ads.rewarded_video_loaded.connect(_on_rewarded_video_loaded)
		yandex_ads.rewarded.connect(_on_rewarded)
		yandex_ads.rewarded_video_failed_to_load.connect(_on_rewarded_video_failed_to_load)
		yandex_ads.rewarded_video_closed.connect(_on_rewarded_video_closed)
		
		# Начинаем загрузку рекламы
		yandex_ads.load_rewarded_video()
		print("Загрузка рекламы...")
	else:
		print("Ошибка: YandexAds не найден")

func _on_reward_button_pressed():
	if yandex_ads:
		if yandex_ads.is_rewarded_video_loaded():
			# Показываем рекламу
			yandex_ads.show_rewarded_video()
			is_waiting_for_reward = true
			print("Показ рекламы...")
			reward_button.disabled = true  # Отключаем кнопку во время показа
		else:
			# Повторная попытка загрузки
			yandex_ads.load_rewarded_video()
			print("Реклама ещё не загружена, попробуйте снова")
	else:
		print("Ошибка: YandexAds не доступен")
	
func _on_rewarded_video_loaded():
	print("Реклама готова! Нажмите кнопку")
	reward_button.disabled = false  

# Пользователь получил награду
func _on_rewarded(currency: String, amount: int):
	is_waiting_for_reward = false
	print("Получено: " + str(amount) + " " + currency)
	if currency == "diamond":
		Global.progress.add_diamonds(amount)
		get_tree().current_scene.get_node("Hud").get_script().update_diamonds()
		
		Global.progress.daily_tasks.sub_ads()
		update_number_ads()
	else:
		reward_button.disabled = false  # Активируем кнопку для следующего показа
	# Загружаем следующую рекламу
	yandex_ads.load_rewarded_video()

# Ошибка загрузки рекламы
func _on_rewarded_video_failed_to_load(error_code: int):
	is_waiting_for_reward = false
	print("Ошибка загрузки рекламы: код " + str(error_code))
	reward_button.disabled = false
	# Пробуем загрузить снова через некоторое время
	await get_tree().create_timer(1.0).timeout
	yandex_ads.load_rewarded_video()
	
# Реклама закрыта
func _on_rewarded_video_closed():
	if is_waiting_for_reward:
		# Пользователь закрыл рекламу без награды
		print("Реклама закрыта, награда не получена")
		is_waiting_for_reward = false
		Global.progress.add_diamonds(1)
		get_tree().current_scene.get_node("Hud").get_script().update_diamonds()
		
		Global.progress.daily_tasks.sub_ads()
		update_number_ads()
	else:
		reward_button.disabled = false
	# Загружаем следующую рекламу
	yandex_ads.load_rewarded_video()
	
func update_number_ads() -> void:
	number_ads.text = str(Global.progress.daily_tasks.current_number_ads) + " x"
	if Global.progress.daily_tasks.current_number_ads == 0:
		reward_button.disabled = true
	else:
		reward_button.disabled = false
	
func on_ok_pressed() -> void:
	get_tree().paused = false
	ok_pressed.emit()
	
func fill_task() -> void:
	clear_all.emit()
	fill_task_1.emit(1)
	fill_task_2.emit(2)
	fill_task_3.emit(3)

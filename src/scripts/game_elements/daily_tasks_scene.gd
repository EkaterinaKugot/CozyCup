extends Control

@onready var task_1: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task
@onready var task_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task2
@onready var task_3: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Task3

@onready var ok: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Ok

@onready var reward_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/Ads
@onready var number_ads: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/NumberAds

@onready var yandex_ads: YandexAds = $YandexAds

var is_waiting_for_reward: bool = false
var is_waiting_for_interstitial: bool = false

signal clear_all
signal fill_task_1(idx: int)
signal fill_task_2(idx: int)
signal fill_task_3(idx: int)
signal ok_pressed

func _ready() -> void:
	get_tree().paused = true
	ok.pressed.connect(on_ok_pressed)
	fill_task()
	
	reward_button.pressed.connect(_on_interstitial_button_pressed)
	update_number_ads()
	
	if yandex_ads:
		# Подключаем сигналы YandexAds для межстраничной рекламы
		yandex_ads.interstitial_loaded.connect(_on_interstitial_loaded)
		yandex_ads.interstitial_failed_to_load.connect(_on_interstitial_failed_to_load)
		yandex_ads.interstitial_closed.connect(_on_interstitial_closed)
		
		# Начинаем загрузку межстраничной рекламы
		yandex_ads.load_interstitial()
		print("Загрузка межстраничной рекламы...")
	else:
		print("Ошибка: YandexAds не найден")

# Обработчик нажатия кнопки
func _on_interstitial_button_pressed():
	if yandex_ads:
		if yandex_ads.is_interstitial_loaded():
			# Показываем межстраничную рекламу
			yandex_ads.show_interstitial()
			is_waiting_for_interstitial = true
			print("Показ межстраничной рекламы...")
			reward_button.disabled = true  # Отключаем кнопку во время показа
		else:
			# Повторная попытка загрузки
			yandex_ads.load_interstitial()
			print("Реклама ещё не загружена, попробуйте снова")
	else:
		print("Ошибка: YandexAds не доступен")

# Межстраничная реклама успешно загружена
func _on_interstitial_loaded():
	print("Межстраничная реклама готова! Нажмите кнопку")

# Ошибка загрузки межстраничной рекламы
func _on_interstitial_failed_to_load(error_code: int):
	is_waiting_for_interstitial = false
	print("Ошибка загрузки рекламы: код " + str(error_code))
	reward_button.disabled = false
	# Пробуем загрузить снова через некоторое время
	await get_tree().create_timer(1.0).timeout
	yandex_ads.load_interstitial()

# Межстраничная реклама закрыта
func _on_interstitial_closed():
	print("Межстраничная реклама закрыта")
	if is_waiting_for_interstitial:
		is_waiting_for_interstitial = false
		Global.progress.add_diamonds(1)
		
		Global.progress.daily_tasks.sub_ads()
		update_number_ads()
	else:
		reward_button.disabled = false
	# Загружаем следующую рекламу
	yandex_ads.load_interstitial()
	
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

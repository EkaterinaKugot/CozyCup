extends Resource
class_name ClientsList

@export var clients: Array[Texture]:  # Массив путей к ассетам клиентов
	get:
		return clients

@export var greetings: Array[String] = [
	"Здравствуйте",
	"Добрый день",
	"Привет",
	""
]  # Массив слов приветствия
		
@export var requests: Array[String] = [
	"Можно",
	"Приготовьте",
	"Сделайте",
	"Налейте"
]# Массив слов просьбы

@export var ownership: Array[String] = ["мне", ""] # Массив слов владения
@export var politeness: Array[String] = [", пожалуйста,", ""] # Массив слов вежливости

@export var name_recipe: Dictionary: # Словарь названия рецепта кофе
	get:
		return name_recipe
		
@export var roasts: Dictionary = {
	"grains_medium": "средней обжарки", 
	"grains_light": "светлой обжарки", 
	"grains_dark": "темной обжарки"
} # Словарь типов обжарки

@export var type_milk: Dictionary = {
	"cow_milk": ["с обычным молоком", "с коровьим молоком", "на обычном молоке", "на коровьем молоке"], 
	"oat_milk": ["с овсяным молоком", "на овсяном молоке"], 
	"coconut_milk": ["с кокосовым молоком", "на кокосовом молоке"], 
	"almond_milk": ["с миндальным молоком", "на миндальном молоке"], 
	"soy_milk": ["с соевым молоком", "на соевом молоке"], 
	"banana_milk": ["с банановым молоком", "на банановом молоке"]
} # Словарь типов молока

@export var servings: Dictionary = {
	1: ["с одной порцией"], 
	2: ["с двумя порциями", "с двойной порцией"], 
	3: ["с тремя порциями", "с тройной порцией"]
} # Словарь количества порциий

@export var no_sweet: Array[String] = ["без сахара", "несладкий"] # Массив слов без сладости

@export var sweeteners: Dictionary = {
	"sugar": "сахара", 
	"coconut_syrup": "кокосового сиропа", 
	"almond_syrup": "миндального сиропа", 
	"peanut_syrup": "арахисового сиропа", 
	"hazelnut_syrup": "фундучного сиропа", 
	"pistachio_syrup": "фисташкового сиропа",
	"caramel_syrup": "карамельного сиропа",
	"salted_caramel_syrup": "сиропа с соленой карамелью",
	"vanilla_syrup": "ванильного сиропа",
	"chocolate_syrup": "шоколадного сиропа",
} # Словарь типов сладости

@export var conjunctions: Array[String] = ["и", ","] # Массив союзов

@export var actions: Array[String] = ["добавьте", "посыпьте"] # Массив союзов

@export var toppings: Dictionary = {
	"cocoa_powder": "какао.", 
	"coconut_powder": "кокос.", 
	"cinnamon_powder": "корицу.", 
} # Словарь типов посыпки

@export var min_topping: int = 3 # Минимальное количество посыпки

func fill_name_recipe() -> void:
	for recipe in Global.recipes_list.recipes:
		name_recipe[recipe.id] = recipe.name.to_lower()
		

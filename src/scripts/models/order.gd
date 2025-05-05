class_name Order

var recipe: Recipe:
	get:
		return recipe
	set(value):
		recipe = value
		
var step_ingredient: Dictionary: # Ингредиенты из рецепта + дополнительные
	get:
		return step_ingredient
	set(value):
		step_ingredient = value
		
var text: String: # Текст заказа
	get:
		return text
	set(value):
		text = value

var price: int = 0: # Текст заказа
	get:
		return price
	set(value):
		price = value
		
const lead_time: float = 40.0
var time_is_exceeded: bool = false

func add_ingredient(ingredient: Ingredient, number: int) -> void:
	step_ingredient[ingredient] = number

func calculate_price() -> void:
	for ingredient in step_ingredient.keys():
		price += ingredient.purchase_cost * step_ingredient[ingredient]
	
func add_words(words: String, need_space: bool = true) -> void:
	if need_space:
		text += " "
	text += words

func make_order() -> void:
	self.recipe = Global.progress.opened_recipes.pick_random()
	var order_data: OrderData = Global.order_data
	
	add_introductory_words(order_data)
	
	"""Зерна"""
	# Если в рецепте есть зерна
	var ingredient_roast = add_ingredient_by_category(Ingredient.Category.GRAINS)
	if ingredient_roast != null:
		var roast = order_data.roasts[ingredient_roast.id]
		add_words(roast)
	
	"""Вода"""
	# Если в рецепте есть вода
	add_ingredient_by_category(Ingredient.Category.WATER)
		
	"""Молоко"""
	# Если в рецепте есть молоко
	var ingredient_milk = add_ingredient_by_category(Ingredient.Category.MILK)
	if ingredient_milk != null:
		var type_milk = order_data.type_milk[ingredient_milk.id].pick_random()
		add_words(type_milk)
	
	if recipe.id == "moccachino":
		add_words(".", false)
		var ingredient_chocolate = Global.progress.select_ingredients_by_id("chocolate_syrup")
		if ingredient_chocolate != null:
			add_ingredient(ingredient_chocolate, 2)
		var ingredient_cacao = Global.progress.select_ingredients_by_id("cocoa_powder")
		if ingredient_cacao != null:
			add_ingredient(ingredient_cacao, 3)
		return
	
	"""Сливки"""
	# Если в рецепте есть сливки
	add_ingredient_by_category(Ingredient.Category.CREAM)
	
	"""Мороженое"""
	# Если в рецепте есть мороженое
	add_ingredient_by_category(Ingredient.Category.ICE_CREAM)
		
	"""Подсластитель""" 	
	var sweetener
	if randf() <= 0.4: # без подсластителя
		sweetener = order_data.no_sweet.pick_random()
	else: # с подсластителем
		# выбираем количество
		var rand_key = randi()%3 + 1 
		var serving = order_data.servings[rand_key].pick_random()
		add_words(serving)
		
		var ingredient_sweetener
		if randf() <= 0.3: # сахар	
			ingredient_sweetener = select_random_ingredient(Ingredient.Category.SUGAR)
			sweetener = order_data.sweeteners[ingredient_sweetener.id]
		else: # сироп
			ingredient_sweetener = select_random_ingredient(Ingredient.Category.SYRUP)
			sweetener = order_data.sweeteners[ingredient_sweetener.id]
		var number = rand_key
		add_ingredient(ingredient_sweetener, number)
	add_words(sweetener)
	
	"""Посыпка""" 		
	if randf() <= 0.4: # без посыпки
		add_words(".", false)
	else: # с посыпкой
		var conjunction = order_data.conjunctions.pick_random()
		if conjunction == "и":
			add_words(conjunction)
		else:
			add_words(conjunction, false)
		
		var action = order_data.actions.pick_random()
		add_words(action)
		
		var ingredient_topping = select_random_ingredient(Ingredient.Category.TOPPING)
		var topping = order_data.toppings[ingredient_topping.id]
		add_words(topping)
		
		var number = order_data.min_topping
		add_ingredient(ingredient_topping, number)
		
func add_introductory_words(order_data: OrderData) -> void:
	var greeting = order_data.greetings.pick_random()
	add_words(greeting, false)
	
	var request = order_data.requests.pick_random()
	if greeting == "":
		add_words(request, false)
	else:
		add_words(request.to_lower())
	
	var ownership = order_data.ownership.pick_random()
	if ownership != "":
		add_words(ownership)
	
	var politeness = order_data.politeness.pick_random()
	if politeness != "":
		add_words(politeness, false)
	var name_recipe = order_data.name_recipe[self.recipe]
	add_words(name_recipe)

func select_random_ingredient(category: Ingredient.Category) -> Ingredient:
	# Выбрали все открытые ингредиенты категории category
	var ingredients = Array(Global.progress.select_ingredients_by_category(category).keys())
	return ingredients.pick_random() # Случайно выбрали ингредиент
	
func add_ingredient_by_category(category: Ingredient.Category) -> Ingredient:
	var ingredient = null
	if self.recipe.check_category(category):
		ingredient = select_random_ingredient(category)
		var number = self.recipe.ingredients[ingredient.category]
		add_ingredient(ingredient, number)
	return ingredient

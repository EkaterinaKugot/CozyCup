class_name Statistics

var old_rating: float:
	get:
		return old_rating
	set(value):
		old_rating = value
var new_rating: float:
	get:
		return new_rating
	set(value):
		new_rating = value
var diff_rating: float:
	get:
		return diff_rating
	set(value):
		diff_rating = value

var served_clients: int = 0:
	get:
		return served_clients
	set(value):
		served_clients = value
var not_served_clients: int = 0:
	get:
		return not_served_clients
	set(value):
		not_served_clients = value
var full_clients: int = 0:
	get:
		return full_clients
	set(value):
		full_clients = value
		
var consumption: int = 0: # расход
	get:
		return consumption
	set(value):
		consumption = value
var income: int = 0: # доход
	get:
		return income
	set(value):
		income = value
var profit: int: # прибыль
	get:
		return profit
	set(value):
		profit = value
	
func set_old_rating() -> void:
	old_rating = Global.progress.rating

func set_new_rating() -> void:
	new_rating = Global.progress.rating
	
func calculate_diff_rating() -> void:
	diff_rating = old_rating - new_rating
	
func add_served_clients() -> void:
	served_clients += 1
	
func add_not_served_clients() -> void:
	not_served_clients += 1

func calculate_full_clients() -> void:
	full_clients = not_served_clients + served_clients 
	
func add_consumption(value: int) -> void:
	consumption += value
	
func add_income(value: int) -> void:
	income += value
	
func calculate_profit() -> void:
	profit = income - consumption

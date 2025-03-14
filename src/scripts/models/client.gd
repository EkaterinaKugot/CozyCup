class_name Client

var client_texture: Texture:
	get:
		return client_texture
	set(value):
		client_texture = value
var order: Order:
	get:
		return order
	set(value):
		order = value
var grade: int:
	get:
		return grade
	set(value):
		grade = value
var order_accept: bool = false


func _init() -> void:
	self.client_texture = random_client_texture()
	# Создаем новый заказ и формируем текст
	self.order = Order.new()
	self.order.make_order()
	self.order.calculate_price()
	print(self.order.text)
	print(self.order.step_ingredient)
	print(self.order.price)
	
func random_client_texture() -> Texture:
	return Global.order_data.clients.pick_random()

func accept_order() -> void:
	self.order_accept = true
	
func exceed_time() -> void:
	self.order.time_is_exceeded = true

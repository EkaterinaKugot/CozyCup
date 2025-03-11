class_name Client

var client_texture: Texture:
	get:
		return client_path
	set(value):
		client_path = value
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
var text: String:
	get:
		return text
	set(value):
		text = value


func _init() -> void:
	self.client_path = random_client_path()
	
	
func random_client_path() -> String:
	return Global.clients_list.clients.pick_random()

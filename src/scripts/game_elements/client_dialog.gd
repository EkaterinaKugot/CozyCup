extends Control

@onready var asset: TextureRect = $AssetClient/Asset
@onready var dialog_window: PanelContainer = $DialogWindow
@onready var text: Label = $DialogWindow/MarginContainer/VBoxContainer/Text
@onready var refuse: Button = $DialogWindow/MarginContainer/VBoxContainer/HBoxContainer/Refuse
@onready var accept: Button = $DialogWindow/MarginContainer/VBoxContainer/HBoxContainer/Accept

signal disabled_bottom_hud
signal undisabled_bottom_hud
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refuse.pressed.connect(on_refuse_pressed)
	accept.pressed.connect(on_accept_pressed)
	
	asset.texture = GameDay.client.client_texture
	text.text = GameDay.client.order.text
	
	if GameDay.client.order_accept: # диалог
		dialog_window.visible = false
	else:
		dialog_window.visible = true
		disabled_bottom_hud.emit()
	
	if GameDay.client_is_waiting: # сам клиент
		visible = false
		undisabled_bottom_hud.emit()
	else:
		visible = true
	
func on_refuse_pressed() -> void:
	visible = false
	undisabled_bottom_hud.emit()
	
	GameDay.refuse_order()
	create_new_client()
	
func on_accept_pressed() -> void:
	dialog_window.visible = false
	undisabled_bottom_hud.emit()
	GameDay.start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible and not GameDay.client_is_waiting:
		dialog_window.visible = true
		visible = true
		disabled_bottom_hud.emit()

func create_new_client() -> void:
	GameDay.create_new_client()
	GameDay.start_waiting_client()
	asset.texture = GameDay.client.client_texture
	text.text = GameDay.client.order.text

func _on_asset_client_order_is_given() -> void:
	visible = false
	GameDay.end_timer()
	GameDay.create_new_coffe_cup() # создаем новую кружку
	
	create_new_client()
	
	var coffee_cup = get_tree().current_scene.get_node("ControlCoffeeCup").get_node("CoffeeCup")
	if coffee_cup != null:
		coffee_cup.clean_added_instance() # визуально очистили
		coffee_cup.display_ingredients()
		coffee_cup.get_node("GlowEffect").visible = false

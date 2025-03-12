extends Control

@onready var asset: TextureRect = $Asset
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
	
	GameDay.client.refuse_order()
	GameDay.create_new_client()
	asset.texture = GameDay.client.client_texture
	text.text = GameDay.client.order.text
	
	GameDay.start_waiting_client()
	
func on_accept_pressed() -> void:
	dialog_window.visible = false
	undisabled_bottom_hud.emit()
	GameDay.client.accept_order()
	GameDay.client.start_timer()
	
	# Должно пойти время

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible and not GameDay.client_is_waiting:
		visible = true

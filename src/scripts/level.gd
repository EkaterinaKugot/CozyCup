extends Control

signal leve_hud_visible()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("leve_hud_visible")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

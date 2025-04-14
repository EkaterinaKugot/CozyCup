extends PanelContainer

@onready var label_diamonds: Label = $TextPanel/Diamonds
@onready var ready_circle: Panel = $DailyTasks/Ready

func _ready() -> void:
	label_diamonds.text = str(Global.progress.diamonds)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.progress.daily_tasks.check_need_accept():
		ready_circle.visible = true
	else:
		ready_circle.visible = false
	
	label_diamonds.text = str(Global.progress.diamonds)

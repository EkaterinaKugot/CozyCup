extends VBoxContainer


@onready var label_diamonds: Label = $DiamondPanel/TextPanel/Diamonds
@onready var ready_circle: Panel = $DiamondPanel/DailyTasks/Ready

@onready var changing_diamonds: Label = $ChangingDiamonds
@onready var animation_player: AnimationPlayer = $"../../../../AnimationPlayer"

const good_color: Color = Color.FOREST_GREEN
const bad_color: Color = Color.RED

func _ready() -> void:
	label_diamonds.text = str(Global.progress.diamonds)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.progress.daily_tasks.check_need_accept():
		ready_circle.visible = true
	else:
		ready_circle.visible = false
	
	label_diamonds.text = str(Global.progress.diamonds)
	
func show_changing_diamonds(number_diamonds: int, is_positive: bool = true) -> void:
	if is_positive:
		changing_diamonds.text = "+"
		changing_diamonds.add_theme_color_override("font_color", good_color)
	else:
		changing_diamonds.text = "-"
		changing_diamonds.add_theme_color_override("font_color", bad_color)
	changing_diamonds.text += str(abs(number_diamonds))
	
	changing_diamonds.visible = true
	animation_player.play("fade_in_diamonds")
	await animation_player.animation_finished
	
	animation_player.play("fade_out_diamonds")
	await animation_player.animation_finished
	changing_diamonds.visible = false

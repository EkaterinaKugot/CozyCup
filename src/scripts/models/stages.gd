class_name StagesGame

enum Stage{
	PURCHASE,
	OPENING,
	GAME,
	CLOSING,
	STATISTIC,
	MENU
}

var current_stage: Stage:
	get:
		return current_stage
	set(value):
		current_stage = value

func start_purchase_stage() -> void:
	current_stage = Stage.PURCHASE
	
func start_opening_stage() -> void:
	current_stage = Stage.OPENING
	
func start_game_stage() -> void:
	current_stage = Stage.GAME

func start_closing_stage() -> void:
	current_stage = Stage.CLOSING

func start_statistic_stage() -> void:
	current_stage = Stage.STATISTIC

func start_menu_stage() -> void:
	current_stage = Stage.MENU

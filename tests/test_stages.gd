extends GutTest

var stages_game_instance = null

func before_each():
	stages_game_instance = StagesGame.new()

func after_each():
	stages_game_instance = null

func test_properties():
	# Проверка начального значения
	assert_eq(stages_game_instance.current_stage, 0, "current_stage должно быть 0 изначально")

func test_start_purchase_stage():
	stages_game_instance.start_purchase_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.PURCHASE, "current_stage должно быть Stage.PURCHASE")

func test_start_opening_stage():
	stages_game_instance.start_opening_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.OPENING, "current_stage должно быть Stage.OPENING")

func test_start_game_stage():
	stages_game_instance.start_game_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.GAME, "current_stage должно быть Stage.GAME")

func test_start_closing_stage():
	stages_game_instance.start_closing_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.CLOSING, "current_stage должно быть Stage.CLOSING")

func test_start_statistic_stage():
	stages_game_instance.start_statistic_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.STATISTIC, "current_stage должно быть Stage.STATISTIC")

func test_start_menu_stage():
	stages_game_instance.start_menu_stage()
	assert_eq(stages_game_instance.current_stage, StagesGame.Stage.MENU, "current_stage должно быть Stage.MENU")

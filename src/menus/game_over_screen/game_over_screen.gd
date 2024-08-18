extends Control

func _ready() -> void:
	$FinalScore.text = "Final Score: " + str(Globals.score)
	$FinalScore.position.x = Globals.SCREEN_WIDTH / 2 - $FinalScore.get_rect().size.x / 2
	$Label.position.x = Globals.SCREEN_WIDTH / 2 - $Label.get_rect().size.x / 2
	$TryAgainButton.position.x = Globals.SCREEN_WIDTH / 2 - $TryAgainButton.size.x / 2
	$MainMenuButton.position.x = Globals.SCREEN_WIDTH / 2 - $MainMenuButton.size.x / 2
	
	var high_score = Globals.load_high_score()
	
	# TODO: show some kind of congrats message when you beat your high score
	if Globals.score > high_score:
		high_score = Globals.score
		Globals.save_high_score(high_score)
	
	$HighScore.text = "Highest Score: " + str(high_score)
	$HighScore.position.x = Globals.SCREEN_WIDTH / 2 - $HighScore.get_rect().size.x / 2

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_screen/start_screen.tscn")

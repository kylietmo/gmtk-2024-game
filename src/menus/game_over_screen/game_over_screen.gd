extends Control

@onready var try_again_button: Button = $HBoxContainer3/TryAgainButton
@onready var final_score_label: Label = $VBoxContainer/FinalScore
@onready var high_score_label: Label = $VBoxContainer/HighScore

func _ready() -> void:
	try_again_button.grab_focus()
	final_score_label.text = "Final Score: " + str(Globals.score)
	
	var high_score = Globals.load_high_score()
	
	# TODO: show some kind of congrats message when you beat your high score
	if Globals.score > high_score:
		high_score = Globals.score
		Globals.save_high_score(high_score)
	
	high_score_label.text = "Highest Score: " + str(high_score)

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_screen/start_screen.tscn")

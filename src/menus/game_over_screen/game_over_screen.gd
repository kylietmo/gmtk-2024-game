extends Control

func _ready() -> void:
	$FinalScore.text = "Final Score: " + str(Globals.score)

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_screen/start_screen.tscn")

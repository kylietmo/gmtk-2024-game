extends Control

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_how_to_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/how_to_play_screen/how_to_play_screen.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/credits_screen/credits_screen.tscn")

extends Control

func _ready() -> void:
	$VBoxContainer/BackButton.grab_focus()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_screen/start_screen.tscn")

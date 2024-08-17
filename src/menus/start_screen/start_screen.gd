extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	$Label.position.x = Globals.SCREEN_WIDTH / 2 - $Label.get_rect().size.x / 2
	$StartButton.position.x = Globals.SCREEN_WIDTH / 2 - $StartButton.size.x / 2
	$QuitButton.position.x = Globals.SCREEN_WIDTH / 2 - $QuitButton.size.x / 2

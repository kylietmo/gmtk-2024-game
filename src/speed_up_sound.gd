extends AudioStreamPlayer2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if InputBuffer.is_action_press_buffered("size_small") and not %Player.is_cooling_down:
		play()

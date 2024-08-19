extends Sprite2D

var direction = 1

func _ready() -> void:
	if randf() < 0.5:
		direction = -1
	else:
		direction = 1

func _process(delta: float) -> void:
	rotation_degrees += .5 * direction

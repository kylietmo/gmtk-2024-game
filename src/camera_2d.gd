extends Camera2D

@onready var SMALL_SHAKE_STRENGTH = Globals.IN_BOUNDS_HEIGHT / 100
@onready var LARGE_SHAKE_STRENGTH = Globals.IN_BOUNDS_HEIGHT / 25
@onready var SHAKE_FADE = Globals.IN_BOUNDS_HEIGHT / 200

var shake_strength = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("size_small"):
		apply_small_shake()

	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, SHAKE_FADE * delta)
		offset = random_offset()

func apply_small_shake() -> void:
	shake_strength = SMALL_SHAKE_STRENGTH
	
func apply_large_shake() -> void:
	shake_strength = LARGE_SHAKE_STRENGTH

func random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)

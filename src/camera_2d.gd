extends Camera2D

@onready var SMALL_SHAKE_STRENGTH = Globals.IN_BOUNDS_HEIGHT / 100
@onready var LARGE_SHAKE_STRENGTH = Globals.IN_BOUNDS_HEIGHT / 20
@onready var SHAKE_FADE = Globals.IN_BOUNDS_HEIGHT / 200

@onready var player : Player = %Player

var shake_strength = 0.0
var camera_y_offset = Globals.IN_BOUNDS_HEIGHT / 15
var starting_y_position : float
var movement_allowed = true

func _ready() -> void:
	starting_y_position = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("size_small") and player.current_size != player.sizes.SMALL and player.current_size != player.sizes.MASSIVE and not player.is_dashing:
		if movement_allowed:
			apply_small_shake()
			position.y -= camera_y_offset
			movement_allowed = false
			$CameraResetTimer.start(player.SMALL_SIZE_DURATION + 2*player.SIZE_TRANSITION_DURATION)
		
	if Input.is_action_just_pressed("size_large") and player.current_size != player.sizes.LARGE and player.current_size != player.sizes.MASSIVE and not player.is_dashing:
		if movement_allowed:
			position.y += camera_y_offset
			movement_allowed = false
			$CameraResetTimer.start(player.LARGE_SIZE_DURATION + 2*player.SIZE_TRANSITION_DURATION)

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


func _on_camera_reset_timer_timeout() -> void:
	position.y = starting_y_position
	movement_allowed = true

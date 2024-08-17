extends CharacterBody2D
class_name Player

@export var SPEED = Globals.IN_BOUNDS_WIDTH
@export var ACCELERATION = Globals.IN_BOUNDS_WIDTH / 5
@export var DECELERATION = Globals.IN_BOUNDS_WIDTH / 5
@export var PLAYER_SIZE = Globals.IN_BOUNDS_WIDTH / 25
@export var SIZE_TRANSITION_DURATION = 0.1
@export var SIZE_CHANGE_DURATION = 0.25

var LARGE_SCALE_VEC = Vector2(Globals.LARGE_SIZE_SCALE, Globals.LARGE_SIZE_SCALE)
var MEDIUM_SCALE_VEC = Vector2(Globals.MEDIUM_SIZE_SCALE, Globals.MEDIUM_SIZE_SCALE)
var SMALL_SCALE_VEC = Vector2(Globals.SMALL_SIZE_SCALE, Globals.SMALL_SIZE_SCALE)

enum sizes {
	SMALL,
	MEDIUM,
	LARGE
}

@onready var current_size = sizes.MEDIUM

func _ready() -> void:
	scale = MEDIUM_SCALE_VEC
	position.y = Globals.PLAYER_START_Y
	
func _physics_process(delta: float) -> void:
	var tween = create_tween()
	
	if Input.is_action_just_pressed("size_small"):
		tween.tween_property(self, "scale", SMALL_SCALE_VEC, SIZE_TRANSITION_DURATION)
		tween.parallel().tween_property(self, "current_size", sizes.SMALL, 0)
		tween.tween_interval(SIZE_CHANGE_DURATION)
		tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
		tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)

	if Input.is_action_just_pressed("size_large"):
		tween.tween_property(self, "scale", LARGE_SCALE_VEC, SIZE_TRANSITION_DURATION)
		tween.parallel().tween_property(self, "current_size", sizes.LARGE, 0)
		tween.tween_interval(SIZE_CHANGE_DURATION)
		tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
		tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BreakableObstacle and current_size == sizes.LARGE:
		body.queue_free()
		Globals.score += 1
	#else:
		#get_tree().change_scene_to_file("res://menus/game_over_screen/game_over_screen.tscn")

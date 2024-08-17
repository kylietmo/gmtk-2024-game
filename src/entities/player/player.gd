extends CharacterBody2D

@export var SPEED = 1000.0
@export var ACCELERATION = 100.0
@export var DECELERATION = 50.0
@export var BIG_SIZE_SCALE = 1.5
@export var SMALL_SIZE_SCALE = 0.5
@export var SIZE_CHANGE_DURATION = 0.1

var BIG_SCALE_VEC = Vector2(BIG_SIZE_SCALE, BIG_SIZE_SCALE)
var SMALL_SCALE_VEC = Vector2(SMALL_SIZE_SCALE, SMALL_SIZE_SCALE)

func _physics_process(delta: float) -> void:	
	if Input.is_action_just_pressed("scale_toggle"):
		var tween = create_tween()

		if scale == SMALL_SCALE_VEC:
			tween.tween_property(self, "scale", BIG_SCALE_VEC, SIZE_CHANGE_DURATION)
		else:
			tween.tween_property(self, "scale", SMALL_SCALE_VEC, SIZE_CHANGE_DURATION)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://menus/game_over_screen/game_over_screen.tscn")

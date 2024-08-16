extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var SCALE_MULTIPLIER = 1.1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("scale_up"):
		scale *= SCALE_MULTIPLIER
	
	if Input.is_action_pressed("scale_down"):
		scale /= SCALE_MULTIPLIER

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

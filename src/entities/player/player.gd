extends CharacterBody2D
class_name Player

@onready var SPEED = Globals.IN_BOUNDS_WIDTH * 1.25
@onready var ACCELERATION = Globals.IN_BOUNDS_WIDTH / 4.0
@onready var DECELERATION = Globals.IN_BOUNDS_WIDTH / 4.0
@onready var PLAYER_SIZE = Globals.IN_BOUNDS_WIDTH / 25.0
@onready var BOUNCE_VELOCITY_SCALAR = 0.8
@onready var SIZE_TRANSITION_DURATION = 0.1
@onready var DASH_TRANSITION_DURATION = 0.1
@onready var SMALL_SIZE_DURATION = 0.18
@onready var LARGE_SIZE_DURATION = 0.3
@onready var INVULNERABILITY_DURATION = 2.0
@onready var SIZE_COOLDOWN_DURATION = 0.5
@onready var DASH_COOLDOWN_DURATION = 0.25
@onready var DASH_X_BOUND_OFFSET = Globals.IN_BOUNDS_WIDTH / 10
@onready var DASH_SPEED = Globals.IN_BOUNDS_WIDTH / 3

@onready var SPRITE = $Sprite2D

var MASSIVE_SCALE_VEC = Vector2(Globals.MASSIVE_SIZE_SCALE, Globals.MASSIVE_SIZE_SCALE)
var LARGE_SCALE_VEC = Vector2(Globals.LARGE_SIZE_SCALE, Globals.LARGE_SIZE_SCALE)
var MEDIUM_SCALE_VEC = Vector2(Globals.MEDIUM_SIZE_SCALE, Globals.MEDIUM_SIZE_SCALE)
var SMALL_SCALE_VEC = Vector2(Globals.SMALL_SIZE_SCALE, Globals.SMALL_SIZE_SCALE)

var SMALL_SPRITE_TEXTURE = preload("res://sprites/Smallstar.png")
var MEDIUM_SPRITE_TEXTURE = preload("res://sprites/Mediumstar.png")
var LARGE_SPRITE_TEXTURE = preload("res://sprites/Bigsun.png")

enum sizes {
	SMALL,
	MEDIUM,
	LARGE,
	REVERSE_LARGE,
	MASSIVE
}

@onready var current_size = sizes.MEDIUM
@onready var is_cooling_down = false
@onready var is_invulnerable = false
@onready var is_dashing = false

var size_tween : Tween

func _ready() -> void:
	scale = MEDIUM_SCALE_VEC
	position.y = Globals.PLAYER_START_Y
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("size_small") and not is_invulnerable and not is_cooling_down and not is_dashing:
		become_small()

	if Input.is_action_just_pressed("size_large") and not is_invulnerable and not is_cooling_down and not is_dashing:
		become_large()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("dash") and direction != 0 and not is_invulnerable:
		rotation_degrees = 0
		if size_tween:
			size_tween.kill()
			
		start_cooldown(DASH_COOLDOWN_DURATION)
		
		var new_x_pos = clampf(position.x + DASH_SPEED * direction, Globals.LEFT_BARRIER_X + DASH_X_BOUND_OFFSET, Globals.RIGHT_BARRIER_X - DASH_X_BOUND_OFFSET)

		size_tween = create_tween()
		size_tween.parallel().tween_property(self, "is_dashing", true, 0)
		size_tween.tween_property(self, "scale", SMALL_SCALE_VEC, 0)
		size_tween.tween_property(self, "position", Vector2(new_x_pos, position.y), DASH_TRANSITION_DURATION)
		size_tween.tween_property(self, "rotation_degrees", direction * -90, 0)
		size_tween.parallel().tween_property(self, "current_size", sizes.SMALL, 0)
		size_tween.tween_interval(SMALL_SIZE_DURATION)
		size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, 0)
		size_tween.tween_property(self, "rotation_degrees", 0, 0)
		size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
		size_tween.parallel().tween_property(self, "is_dashing", false, 0)
		size_tween.connect("finished", _on_size_tween_finished)
		SPRITE.texture = SMALL_SPRITE_TEXTURE
		$SpeedUpSound.play()
	
	if current_size == sizes.SMALL and not is_dashing:
		velocity.x = 0
	elif direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)

	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.x *= BOUNCE_VELOCITY_SCALAR

func become_invulnerable():
	is_invulnerable = true
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", MASSIVE_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(SPRITE, "rotation_degrees", 360, INVULNERABILITY_DURATION)
	size_tween.parallel().tween_property(self, "current_size", sizes.MASSIVE, 0)
	SPRITE.texture = LARGE_SPRITE_TEXTURE
	$InvulnerabilitySound.play()
	$InvulnerableTimer.start(INVULNERABILITY_DURATION)

func become_large(include_cooldown: bool = true, size = sizes.LARGE) -> void:
	rotation_degrees = 0
	
	if include_cooldown:
		start_cooldown(SIZE_COOLDOWN_DURATION)
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", LARGE_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(self, "current_size", size, 0)
	size_tween.tween_interval(LARGE_SIZE_DURATION)
	size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
	
	if is_invulnerable:
		size_tween.parallel().tween_property(self, "is_invulnerable", false, 0)

	size_tween.connect("finished", _on_size_tween_finished)
	SPRITE.texture = LARGE_SPRITE_TEXTURE
	$SlowDownSound.play()
	$KnockbackParticles.restart()


func become_small() -> void:
	start_cooldown(SIZE_COOLDOWN_DURATION)
	rotation_degrees = 0
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", SMALL_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(self, "current_size", sizes.SMALL, 0)
	size_tween.tween_interval(SMALL_SIZE_DURATION)
	size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
	size_tween.connect("finished", _on_size_tween_finished)
	SPRITE.texture = SMALL_SPRITE_TEXTURE
	$SpeedUpSound.play()

 	
func start_cooldown(duration: float):
	is_cooling_down = true
	$CooldownTimer.start(duration)

func _on_size_tween_finished():
	SPRITE.rotation_degrees = 0
	SPRITE.texture = MEDIUM_SPRITE_TEXTURE
	is_dashing = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_invulnerable and body is Obstacle:
		body.broke_platform.emit()
		body.queue_free.call_deferred()
	elif body is BreakableObstacle and current_size == sizes.LARGE:
		body.queue_free.call_deferred()
	else:
		get_tree().change_scene_to_file.call_deferred("res://menus/game_over_screen/game_over_screen.tscn")

func _on_invulnerable_timer_timeout() -> void:
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
	size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
	size_tween.connect("finished", _on_size_tween_finished)
	become_large(false, sizes.REVERSE_LARGE)

func _on_cooldown_timer_timeout() -> void:
	is_cooling_down = false

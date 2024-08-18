extends CharacterBody2D
class_name Player

@onready var SPEED = Globals.IN_BOUNDS_WIDTH * 1.25
@onready var ACCELERATION = Globals.IN_BOUNDS_WIDTH / 4.0
@onready var DECELERATION = Globals.IN_BOUNDS_WIDTH / 4.0
@onready var PLAYER_SIZE = Globals.IN_BOUNDS_WIDTH / 25.0
@onready var SIZE_TRANSITION_DURATION = 0.1
@onready var SMALL_SIZE_DURATION = 0.15
@onready var LARGE_SIZE_DURATION = 0.3
@onready var BOUNCE_VELOCITY_SCALAR = 0.8
@onready var SPRITE  = $Sprite2D

var LARGE_SCALE_VEC = Vector2(Globals.LARGE_SIZE_SCALE, Globals.LARGE_SIZE_SCALE)
var MEDIUM_SCALE_VEC = Vector2(Globals.MEDIUM_SIZE_SCALE, Globals.MEDIUM_SIZE_SCALE)
var SMALL_SCALE_VEC = Vector2(Globals.SMALL_SIZE_SCALE, Globals.SMALL_SIZE_SCALE)

var SMALL_SPRITE_TEXTURE = preload("res://sprites/Small-gnome.png")
var MEDIUM_SPRITE_TEXTURE = preload("res://sprites/Normal-gnome.png")
var LARGE_SPRITE_TEXTURE = preload("res://sprites/Big-gnome.png")

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
	if Input.is_action_just_pressed("size_small"):
		var small_size_tween = create_tween()
		small_size_tween.tween_property(self, "scale", SMALL_SCALE_VEC, SIZE_TRANSITION_DURATION)
		small_size_tween.parallel().tween_property(self, "current_size", sizes.SMALL, 0)
		small_size_tween.tween_interval(SMALL_SIZE_DURATION)
		small_size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
		small_size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
		small_size_tween.connect("finished", _on_size_tween_finished)
		SPRITE.texture = SMALL_SPRITE_TEXTURE

	if Input.is_action_just_pressed("size_large"):
		var large_size_tween = create_tween()
		large_size_tween.tween_property(self, "scale", LARGE_SCALE_VEC, SIZE_TRANSITION_DURATION)
		large_size_tween.parallel().tween_property(self, "current_size", sizes.LARGE, 0)
		large_size_tween.tween_interval(LARGE_SIZE_DURATION)
		large_size_tween.tween_property(self, "scale", MEDIUM_SCALE_VEC, SIZE_TRANSITION_DURATION)
		large_size_tween.parallel().tween_property(self, "current_size", sizes.MEDIUM, 0)
		large_size_tween.connect("finished", _on_size_tween_finished)
		SPRITE.texture = LARGE_SPRITE_TEXTURE

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if current_size != sizes.MEDIUM:
		velocity.x = 0
	elif direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)

	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.x *= BOUNCE_VELOCITY_SCALAR

func _on_size_tween_finished():
	SPRITE.texture = MEDIUM_SPRITE_TEXTURE

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BreakableObstacle and current_size == sizes.LARGE:
		body.queue_free.call_deferred()
	else:
		get_tree().change_scene_to_file.call_deferred("res://menus/game_over_screen/game_over_screen.tscn")

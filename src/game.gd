extends Node


@onready var SPEED = - Globals.IN_BOUNDS_HEIGHT / 4

@onready var MIN_OBSTACLE_WIDTH = Globals.IN_BOUNDS_WIDTH / 8
@onready var MAX_OBSTACLE_WIDTH = Globals.IN_BOUNDS_WIDTH / 4
@onready var MIN_OBSTACLE_HEIGHT = Globals.IN_BOUNDS_HEIGHT / 30
@onready var MAX_OBSTACLE_HEIGHT = Globals.IN_BOUNDS_HEIGHT / 10

@onready var OBSTACLE_SPAWN_OFFSET = Globals.IN_BOUNDS_HEIGHT / 10

@onready var player : Player = %Player
@onready var camera : Camera2D = %Camera2D
@onready var crash_sound : AudioStreamPlayer2D = %CrashSound

var invulnerability_consumable_scene = preload("res://entities/consumables/invulnerability.tscn")

var obstacles : Array[CharacterBody2D] = []
var breakable_obstacle_scene = preload("res://entities/obstacle/breakable_obstacle/breakable_obstacle.tscn")
var platform_one_gap_scene = preload("res://entities/platforms/platform_with_one_gap.tscn")
var platforms_two_gaps_scene = preload("res://entities/platforms/platforms_with_two_gaps.tscn")
var platform_triple_gap_scene = preload("res://entities/platforms/platform_with_triple_gap.tscn")
var platform_left_gap_scene = preload("res://entities/platforms/platform_with_left_gap.tscn")
var platform_midleft_gap_scene = preload("res://entities/platforms/platform_with_midleft_gap.tscn")
var platform_midright_gap_scene = preload("res://entities/platforms/platform_with_midright_gap.tscn")
var platform_right_gap_scene = preload("res://entities/platforms/platform_with_right_gap.tscn")
var platform_double_edge_gap_scene = preload("res://entities/platforms/platform_with_two_edge_gaps.tscn")
var moving_platform_scene = preload("res://entities/platforms/moving_platform.tscn")

var obstacle_scenes : Array[Dictionary] = [
	{'scene': moving_platform_scene, 'probability': 0.1},
	{'scene': platform_one_gap_scene, 'probability': 0.125},
	{'scene': platform_triple_gap_scene, 'probability': 0.125},
	{'scene': platforms_two_gaps_scene, 'probability': 0.1},
	{'scene': platform_left_gap_scene, 'probability': 0.1},
	{'scene': platform_midleft_gap_scene, 'probability': 0.125},
	{'scene': platform_midright_gap_scene, 'probability': 0.125},
	{'scene': platform_right_gap_scene, 'probability': 0.1},
	{'scene': platform_double_edge_gap_scene, 'probability': 0.1}
]

var BREAKABLE_OBSTACLE_SPAWN_PROBABILITY = 0.2
var INVULNERABLE_CONSUMABLE_PROBABILITY = 0.1

func init_obstacle_resources() -> void:
	for scene in obstacle_scenes:
		var platform_row = PlatformRow.new()
		platform_row.probability = 1.0 / obstacle_scenes.size()
		platform_row.scene = scene

func _ready() -> void:
	Globals.score = 0
	spawn_barrier_with_gaps()
	assert_obstacle_probabilities()
	

func _process(delta: float) -> void:
	match player.current_size:
		player.sizes.SMALL:
			SPEED = -Globals.IN_BOUNDS_HEIGHT
		player.sizes.MEDIUM:
			SPEED = -Globals.IN_BOUNDS_HEIGHT / 2
		player.sizes.LARGE:
			SPEED = -Globals.IN_BOUNDS_HEIGHT / 5
		player.sizes.MASSIVE:
			SPEED = -Globals.IN_BOUNDS_HEIGHT * 2
	
	# Update all existing obstacles to be moving up. 
	# TODO: If/when we change the direction of the level we'd need
	# to make this configurable per current direction.
	for o in obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED

func spawn_barrier_with_gaps() -> void:
	var rand_p = randf()
	
	var p_threshold = 0.0
	var platform_scene = obstacle_scenes[0]['scene']
	for o in obstacle_scenes:
		p_threshold += o['probability']
		if rand_p < p_threshold:
			platform_scene = o['scene']
			break
	
	var platform: Obstacle = platform_scene.instantiate()
	
	platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2 + OBSTACLE_SPAWN_OFFSET
	
	(platform as PlatformRow).connect("passed_score_threshold", _on_passed_score_threshold)
	(platform as PlatformRow).connect("passed_spawn_threshold", _on_passed_spawn_threshold)
	
	for child in platform.get_children():
		if child is Obstacle:
			child.connect("broke_platform", _on_broke_platform)
	
	obstacles.append(platform)
	add_child.call_deferred(platform)

func spawn_breakable_obstacle() -> void:
	var platform : BreakableObstacle = breakable_obstacle_scene.instantiate()
	
	var platform_width = Globals.IN_BOUNDS_WIDTH

	platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2.0 + OBSTACLE_SPAWN_OFFSET
	
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x

	platform.scale.x = platform_width / platform_sprite_width
	
	obstacles.append(platform)
	add_child.call_deferred(platform)
	
	platform.connect("passed_score_threshold", _on_passed_score_threshold)
	platform.connect("passed_spawn_threshold", _on_passed_spawn_threshold)
	platform.connect("broke_platform", _on_broke_platform)

func increment_score() -> void:
	Globals.score += 1
	
func spawn_obstacle() -> void:
	var rand = randf()
	if rand <= BREAKABLE_OBSTACLE_SPAWN_PROBABILITY:
		spawn_breakable_obstacle()
	else:
		spawn_barrier_with_gaps()

	if not player.is_invulnerable and rand <= INVULNERABLE_CONSUMABLE_PROBABILITY:
		var consumable : Area2D = invulnerability_consumable_scene.instantiate()
		consumable.position.x = randi_range(Globals.LEFT_BARRIER_X + (Globals.IN_BOUNDS_WIDTH / 75), Globals.RIGHT_BARRIER_X - (Globals.IN_BOUNDS_WIDTH / 75))
		consumable.position.y = Globals.IN_BOUNDS_HEIGHT / 2
		add_child.call_deferred(consumable)

func assert_obstacle_probabilities() -> void:
	var combined_weight : float = obstacle_scenes.reduce(func(sum, info): return sum + info['probability'], 0.0)

	assert(snappedf(combined_weight, 0.001) == 1.0, "ERROR: probability weights in obstacle_scenes must add up to 1, received " + str(combined_weight))

func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)
		
func _on_score_area_body_exited(body: Node2D) -> void:
	if body is Obstacle:
		increment_score()

func _on_passed_score_threshold() -> void:
	increment_score()

func _on_passed_spawn_threshold() -> void:
	spawn_obstacle()

func _on_broke_platform() -> void:
	camera.apply_large_shake()
	crash_sound.play()

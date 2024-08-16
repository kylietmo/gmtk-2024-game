extends Node2D

@export var NUM_OBSTACLES_AT_ONCE = 1
@export var NUM_SECS_BETWEEN_SPAWNS = 2.0
const SPEED = -300.0
@onready var Player = $Player

var CurrTimeUntilSpawn = 0.0
var Obstacles : Array[CharacterBody2D]= []
var DoublePlatformScene = preload("res://scenes/double_platform.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_obstacle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	CurrTimeUntilSpawn += delta
	for o in Obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED
	if CurrTimeUntilSpawn >= NUM_SECS_BETWEEN_SPAWNS:
		spawn_obstacle()
		CurrTimeUntilSpawn = 0.0
	
func spawn_obstacle() -> void:
	
	var obstacle = DoublePlatformScene.instantiate()
	obstacle.position.x = Player.position.x
	obstacle.position.y = get_viewport_rect().end.y
	Obstacles.append(obstacle)
	add_child(obstacle)

func _on_child_exiting_tree(node: Node) -> void:
	if node is DoublePlatform:
		Obstacles.erase(node)

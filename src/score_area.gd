extends Area2D

@onready var player : Player = %Player

const SCORE_COLLIDER_OFFSET = 40

func _ready() -> void:	
	position.y = player.position.y  - SCORE_COLLIDER_OFFSET

extends Area2D

@onready var player: Player = %Player

func _ready() -> void:
	position.y = player.position.y

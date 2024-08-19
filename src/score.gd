extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("score_changed", _on_score_changed)
	
func _on_score_changed(value: int) -> void:
	text = "Score: " + str(value)

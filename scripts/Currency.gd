extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		body._player_stats.currency += 10
		queue_free()

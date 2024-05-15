extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase && position.distance_to(player.position) > 60:
		position += (player.position - position)/speed
		

func _on_detectarea_body_entered(body):
	player = body
	player_chase = true


func _on_detectarea_body_exited(body):
	player = null
	player_chase = false

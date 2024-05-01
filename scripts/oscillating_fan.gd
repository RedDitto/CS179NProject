extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("side_walk")
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2(0,0))
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = false
		player_chase = false
	
func enemy():
	pass

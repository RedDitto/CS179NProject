extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase:
		#position += (player.position - position) / speed
		
		var direction = (player.position - position).normalized()
		var desired_velocity = direction * speed
		var steering = (desired_velocity - velocity) * delta * 2.5
		velocity += steering
		move_and_slide()
		
		$AnimatedSprite2D.play("walk")
		
		#move_and_collide(Vector2(0,0))
	else:
		$AnimatedSprite2D.play("fridge_idle")


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


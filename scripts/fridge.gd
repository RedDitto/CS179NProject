extends CharacterBody2D

var speed = 60
var acceleration = 7
var player_chase = false
var player = null

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _physics_process(delta):
	if player_chase:
		#position += (player.position - position) / speed
		
		#var direction = (player.position - position).normalized()
		#var desired_velocity = direction * speed
		#var steering = (desired_velocity - velocity) * delta * 2.5
		#velocity += steering
		#move_and_slide()
		
		var direction = Vector2.ZERO
		navigation_agent.target_position = player.global_position
		
		
		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		
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
		player = null
		player_chase = false
	
func enemy():
	pass



func _on_timer_timeout():
	if player != null:
		navigation_agent.target_position = player.global_position
	

extends CharacterBody2D

var max_speed = 100
var max_steering = 2.5
var player = null
var player_chase = false
var avoid_force = 1000

@onready var raycasts: Node2D = get_node("Raycasts")

func _physics_process(delta):
	if player_chase:
		var steering = Vector2.ZERO
		steering += seek_steering()
		steering += avoid_obtacles_steering()
		steering = steering.limit_length(max_steering)
		
		velocity += steering
		velocity = velocity.limit_length(max_speed)
		
		move_and_slide()

func seek_steering():
	
	#DEBUG WTIH MOUSE MOVEMENT
	#var desired_velocity = (get_global_mouse_position() - position).normalized() * max_speed 
	
	#DEBUG WITH PLAYER MOVEMENT
	var desired_velocity = (player.position - position).normalized() * max_speed
	
	return desired_velocity - velocity

func avoid_obtacles_steering():
	raycasts.rotation = velocity.angle()
	
	for raycast in raycasts.get_children():
		raycast.target_position = Vector2(velocity.length(), 0.0)
		if raycast.is_colliding():
			var obstacle = raycast.get_collider()
			return (position + velocity - obstacle.position).normalized() * avoid_force
	
	return Vector2.ZERO
	
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false

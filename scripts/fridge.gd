extends CharacterBody2D

var speed = 60
var acceleration = 7
var player_chase = false
var player = null

@export var target: Node2D = null

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _ready():
	call_deferred("seeker_setup")
	
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if player_chase:
		if target:
			navigation_agent.target_position = target.global_position
		if navigation_agent.is_navigation_finished():
			return
		
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		var new_velocity = current_agent_position.direction_to(next_path_position) * speed
		
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		
		move_and_slide()
		$AnimatedSprite2D.play("walk")
		#move_and_collide(Vector2(0,0))
	else:
		$AnimatedSprite2D.play("fridge_idle")



func _on_detection_area_body_entered(body):
	#print("ENTERED")
	if body.is_in_group("Player"):
		player = body
		player_chase = true
		


func _on_detection_area_body_exited(body):
	#if body.is_in_group("Player"):
		#player = null
		#player_chase = false
	pass
func enemy():
	pass



func _on_timer_timeout():
	if player != null:
		navigation_agent.target_position = player.global_position
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

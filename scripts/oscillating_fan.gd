extends CharacterBody2D

@export var _enemy_stats : Enemy_Stats

var speed = 50
var player_chase = false
var player = null

@export var target: Node2D = null

@onready var navigation_agent_2d = $Navigation/NavigationAgent2D

func _ready():
	call_deferred("seeker_setup")
	$Health_Bar.visible = false
	
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func _physics_process(delta):
	if player_chase and Global._player_stats.health > 0:
		$Health_Bar.value = _enemy_stats.health
		if target:
			navigation_agent_2d.target_position = target.global_position
		if navigation_agent_2d.is_navigation_finished():
			return
		
		var current_agent_position = global_position
		var next_path_position = navigation_agent_2d.get_next_path_position()
		var new_velocity = current_agent_position.direction_to(next_path_position) * speed
		
		if navigation_agent_2d.avoidance_enabled:
			navigation_agent_2d.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		
		move_and_slide()
		
		$AnimatedSprite2D.play("side_walk")
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		$Health_Bar.visible = true
		$Health_Bar.max_value = _enemy_stats.max_health
		$Health_Bar.value = _enemy_stats.health
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
	#if body.is_in_group("Player"):
		#player = false
		#player_chase = false
	pass

func deal_with_damage(damage):
	pass

func enemy():
	pass


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

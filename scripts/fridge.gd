extends CharacterBody2D

var speed = 60
var acceleration = 7
var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false

signal health_loss

@export var _enemy_stats : Enemy_Stats


@export var target: Node2D = null

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _ready():
	call_deferred("seeker_setup")
	
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if alive:
		if player_chase:
			if target:
				#print(target.global_position)
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
	else:
		self.queue_free()


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
	
func deal_with_damage(damage):
	if can_take_damage == true:
		if _enemy_stats.health - damage < 0:
			_enemy_stats.health = 0
		else:
			_enemy_stats.health = _enemy_stats.health - damage
		$take_damage_cooldown.start()
		print("cooldown start")
		can_take_damage = false
		print("fridge health = ", _enemy_stats.health)
		emit_signal("health_loss", _enemy_stats.health)
		if _enemy_stats.health <= 0:
			alive = false
			
func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
	
func enemy():
	pass



func _on_timer_timeout():
	if player != null:
		navigation_agent.target_position = player.global_position
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity




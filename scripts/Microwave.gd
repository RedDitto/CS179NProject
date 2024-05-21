extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false

@onready var navigation_agent_2d = $Navigation/NavigationAgent2D
@onready var health_bar = $Health_Bar

signal health_loss

@export var _enemy_stats : Enemy_Stats

@export var target: Node2D = null

func _ready():
	call_deferred("seeker_setup")
	health_bar.visible = false
	
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position
	

func _physics_process(delta):
	if alive:
		if player_chase:
			if target:
				navigation_agent_2d.target_position = target.global_position
			if navigation_agent_2d.is_navigation_finished():
				#print("navigation finished")
				return
			
			var current_agent_position = global_position
			var next_path_position = navigation_agent_2d.get_next_path_position()
			var new_velocity = current_agent_position.direction_to(next_path_position) * speed
			
			if navigation_agent_2d.avoidance_enabled:
				navigation_agent_2d.set_velocity(new_velocity)
			else:
				_on_navigation_agent_2d_velocity_computed(new_velocity)
			
			move_and_slide()
			
			$AnimatedSprite2D.play("chase")
			
		else:
			$AnimatedSprite2D.play("idle")
	else:
		self.queue_free()

	
func deal_with_damage(damage):
	if can_take_damage == true:
		if _enemy_stats.health - damage < 0:
			_enemy_stats.health = 0
		else:
			_enemy_stats.health = _enemy_stats.health - damage
		$take_damage_cooldown.start()
		can_take_damage = false
		print("microwave health = ", _enemy_stats.health)
		emit_signal("health_loss", _enemy_stats.health)
		if _enemy_stats.health <= 0:
			alive = false

func enemy():
	pass

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true
		health_bar.visible = true



func _on_detection_area_body_exited(body):
	#if body.is_in_group("Player"):
		#player = null
	pass

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_take_damage_cooldown_timeout():
	can_take_damage = true


func _on_timer_timeout():
	if player != null:
		navigation_agent_2d.target_position = player.global_position

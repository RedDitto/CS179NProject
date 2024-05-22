extends CharacterBody2D

@export var _enemy_stats : Enemy_Stats

var speed = 50
var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false

@onready var health_bar = $Health_Bar


signal health_loss

@export var _enemy_stats : Enemy_Stats

var health = 100

@export var target: Node2D = null

@onready var navigation_agent_2d = $Navigation/NavigationAgent2D

func _ready():
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	call_deferred("seeker_setup")
  $Health_Bar.visible = false
	
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func _physics_process(delta):
  if alive:
    $Health_Bar.value = _enemy_stats.health
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
			
			$AnimatedSprite2D.play("side_walk")
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
	else:
		self.queue_free()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
    $Health_Bar.visible = true
		$Health_Bar.max_value = _enemy_stats.max_health
		$Health_Bar.value = _enemy_stats.health
    #print("FAN DETECTS PLAYER")
		player = body
		player_chase = true
		health_bar.visible = true

func _on_detection_area_body_exited(body):
	#if body.is_in_group("Player"):
		#player = false
		#player_chase = false
	pass

func deal_with_damage(damage):
	if can_take_damage == true:
		if health - damage < 0:
			health = 0
		else:
			health = health - damage
		$take_damage_cooldown.start()
		can_take_damage = false
		print("fan health = ", health)
		emit_signal("health_loss", health)
		if health <= 0:
			alive = false

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
func enemy():
	pass


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_timer_timeout():
	if player != null:
		navigation_agent_2d.target_position = player.global_position

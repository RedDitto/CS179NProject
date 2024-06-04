extends CharacterBody2D

var currency_drop = preload("res://Scenes/currency.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
var speed = 60
var acceleration = 7
var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false
var isPoisoned = false
signal health_loss
var in_knockback = false
@export var knockback_modifier : float
@export var enabled_knockback : bool = true
@export var _enemy_stats : Enemy_Stats
@onready var hit_animation_player = $Hit_AnimationPlayer
var health = 200
var max_health = 200
var random = RandomNumberGenerator.new()
var aimAhead = false


@onready var health_bar = $Health_Bar

@export var target: Node2D = null

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _ready():
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	call_deferred("seeker_setup")
	health_bar.visible = false
	random.randomize()
	aimAhead = (random.randi() % 10) == 1
	
func seeker_setup():
	await get_tree().physics_frame
	#if target:
		#navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if alive:
		if player_chase:
			if target:
				pass
				#print(target.global_position)
				#var dist = (player.position - self.position).length()
				#if aimAhead:
					#navigation_agent.target_position = (target.global_position*44)
				#else:
					#navigation_agent.target_position = target.global_position*44
			if navigation_agent.is_navigation_finished():
				return
			if !in_knockback:
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
		var currency = currency_drop.instantiate()
		get_parent().add_child(currency)
		currency.position = self.position
		
		var exp = explosion.instantiate()
		exp.position = position
		get_parent().add_child(exp)
		Global.fridgesKilled += 1
		self.queue_free()

func fridge2():
	pass
	
func _on_detection_area_body_entered(body):
	#print("ENTERED")
	if body.is_in_group("Player"):
		player = body
		player_chase = true
		health_bar.visible = true
		#body.poison()
		

func poison() :
	isPoisoned = true
	$poison_timer.wait_time = 1
	$poison_timer.start()
		


func _on_detection_area_body_exited(body):
	#if body.is_in_group("Player"):
		#player = null
		#player_chase = false
	pass
	
func deal_with_damage(damage):
	if can_take_damage == true:
		if health - damage < 0:
			health = 0
		else:
			health = health - damage
		if enabled_knockback:
			in_knockback = true
			var knockback_direction = navigation_agent.target_position.direction_to(self.global_position)
			velocity = knockback_direction * knockback_modifier
			$Knockback_timer.start()
			
		$take_damage_cooldown.start()
		
		
		
		print("cooldown start")
		can_take_damage = false
		print("fridge health = ", health)
		emit_signal("health_loss", health)
		if health <= 0:
			alive = false
		else:
			hit_animation_player.play("hit")



func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
	
func enemy():
	pass



func _on_timer_timeout():
	if player != null:
		var dist = abs((player.global_position - self.global_position).length())
		#print(dist)
		#print("player")
		#print(player.global_position)
		#print("fridge")
		#print(self.global_position)
		if dist > 60 && aimAhead:
			navigation_agent.target_position = player.global_position + player.velocity.normalized() * 50
		else:
			navigation_agent.target_position = player.global_position
			
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_knockback_timer_timeout():
	in_knockback = false


func _on_poison_timer_timeout():
	deal_with_damage(max_health/10)

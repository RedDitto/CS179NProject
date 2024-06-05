extends CharacterBody2D

var timescript = preload("res://scripts/Panel.gd")
var time = timescript.new()
var currency_drop = preload("res://Scenes/currency.tscn")
var bossexplosion = preload("res://Scenes/BossExplosion.tscn")
var defaultSpeed = 30
var speed = 30
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
const fridgePATH = preload('res://Scenes/fridge2.tscn')
var health = 1000/Global.mode
var max_health = 1000/Global.mode
var rd = RandomNumberGenerator.new()
var numFridges = 0
var maxFridges = 12
var isAngry = false
var hasBeenAngry = false



@onready var health_bar = $Health_Bar

@export var target: Node2D = null

@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _ready():
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	call_deferred("seeker_setup")
	health_bar.visible = false
	rd.randomize()
	$Spawn_Timer.wait_time = 5
	$Spawn_Timer.start()
func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position
func startAngry():
	speed = 110
	hasBeenAngry = true
	isAngry = true
	$AngryTimer.wait_time = 10
	$AngryTimer.start()
	

	
	
func _physics_process(delta):
	#if isAngry:
		#speed = 100
	#else:
		#speed = defaultSpeed
	if !hasBeenAngry && health < 1000:
		startAngry()

	if alive:
		if player_chase:
			if target:
				#print(target.global_position)
				navigation_agent.target_position = target.global_position
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
		Global.numruns += 1
		Global.numwins += 1
		#time.paused = true
		#time.bananad = true
		Global.pauseTimer = true
		time._stop()
		var currency = currency_drop.instantiate()
		get_parent().add_child(currency)
		currency.position = self.position
		
		var exp = bossexplosion.instantiate()
		exp.position = position
		get_parent().add_child(exp)
		Global.fridgesKilled += 1
		self.queue_free()


func _on_detection_area_body_entered(body):
	#print("ENTERED")
	if body.is_in_group("Player"):
		player = body
		player_chase = true
		health_bar.visible = true
		#body.poison()
		

#func poison() :
	#isPoisoned = true
	#$poison_timer.wait_time = 1
	#$poison_timer.start()
	#
#func unpoison():
	#isPoisoned = false
	#$poison_timer.stop()


func _on_detection_area_body_exited(body):
	if body.has_method("fridge2"):
		fridgeDied() # or left detection zone
	
func deal_with_damage(damage):
	if player == null: 
		return # immortal until player in its vision so can't kill from outside room
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
		navigation_agent.target_position = player.global_position
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_knockback_timer_timeout():
	in_knockback = false


func _on_poison_timer_timeout():
	deal_with_damage(1)


func _on_spawn_timer_timeout():
	if player != null:
		for i in range(5):
			if numFridges > maxFridges:
				break
			var aaa = fridgePATH.instantiate()
			numFridges += 1
			aaa.position = Vector2(position.x + 80*cos(randf_range(0,100)),80 * sin(randf_range(0,100)) + position.y)
			get_parent().add_child(aaa)
			aaa.health = 50
			aaa.max_health = 100
			aaa.speed = 100 
			if isAngry:
				aaa.speed = 200
			if health < 500:
				aaa.health = 200
				aaa.max_health = 200
				aaa.speed = 150


func fridgeDied():
	numFridges -= 1
	print("fridge died")
	print(numFridges)
	if numFridges < 0: 
		numFridges = 0


func _on_angry_timer_timeout():
	#pass
	isAngry = false
	speed = defaultSpeed

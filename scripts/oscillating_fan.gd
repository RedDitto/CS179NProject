extends CharacterBody2D

var currency_drop = preload("res://Scenes/currency.tscn")

var speed = 50
var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false
var in_knockback = false
var attacking = false

@export var knockback_modifier : float
@export var enabled_knockback : bool = true
@onready var health_bar = $Health_Bar
@onready var hit_animation_player = $Hit_AnimationPlayer

var tornado = preload('res://Scenes/tornado.tscn')

var can_attack = true

signal health_loss

@export var _enemy_stats : Enemy_Stats

var health = 100/Global.mode

@export var target: Node2D = null

@onready var navigation_agent_2d = $Navigation/NavigationAgent2D

func _ready():
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
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
			
			if attacking and can_attack:
				tornado_attack()
				
			if !in_knockback:
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
		var currency = currency_drop.instantiate()
		get_parent().add_child(currency)
		currency.position = self.position
		Global.fansKilled+=1
		self.queue_free()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
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
		if enabled_knockback:
			in_knockback = true
			var knockback_direction = navigation_agent_2d.target_position.direction_to(self.global_position)
			velocity = knockback_direction * knockback_modifier
			$Knockback_timer.start()
		hit_animation_player.play("hit")
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


func _on_knockback_timer_timeout():
	in_knockback = false

func tornado_attack():
	var new_tornado = tornado.instantiate()
	get_tree().get_root().add_child(new_tornado)
	new_tornado.global_position = global_position
	new_tornado.direction = (player.global_position - global_position).normalized()
	#new_tornado.global_rotation = new_tornado.direction.angle() + PI / 2.0
	can_attack = false
	$Attack/attack_cooldown.start()
	
	
func _on_attack_range_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true


func _on_tornado_hurtbox_body_entered(body):
	if body.is_in_group("Player"):
		print('tornado hit player')


func _on_attack_cooldown_timeout():
	can_attack = true
	

func _on_attack_range_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false

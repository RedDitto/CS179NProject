extends CharacterBody2D

signal health_loss
signal damage_enemy

@export var _player_stat : Player_Stats

const PROJECTILE_PATH = preload('res://Scenes/Projectile.tscn')

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var melee_range = false

var attack_in_progress = false

const SPEED = 100
var speed_boost = 0
var current_direction = "none"
var move_direction = "none"
var player_mouse_direction = Vector2(0,0)
var moving = false
var idle = "none"
var animation = "none"


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	if _player_stat.health <= 0:
		player_alive = false #where you would add go back to menu / respawn
		_player_stat.health = 0
		print("Y O U   D I E D")
		self.queue_free()
	
	#projectile shooting
	if Input.is_action_just_pressed("shoot_projectile"):
		shoot()
	$ProjectileDirection.look_at(get_global_mouse_position())
	

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		moving = true
		move_direction = "right"
		play_anim()
		velocity.x = SPEED + speed_boost
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		moving = true
		move_direction = "left"
		play_anim()
		velocity.x = -SPEED - speed_boost
		velocity.y = 0 
	elif Input.is_action_pressed("ui_down"):
		moving = true
		move_direction = "down"
		play_anim()
		velocity.x = 0
		velocity.y = SPEED + speed_boost
	elif Input.is_action_pressed("ui_up"):
		moving = true
		move_direction = "up"
		play_anim()
		velocity.x = 0
		velocity.y = -SPEED - speed_boost
	else:
		moving = false
		play_anim()
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_anim(): 
	var anim = $AnimatedSprite2D
	var rev = false
	
	if moving == true:
		if move_direction == "right":
			if current_direction == "up":
				animation = "back_walk"
			elif current_direction == "down":
				animation = "front_walk"
			elif current_direction == "left":
				rev = true
			else:
				animation = "side_walk"
		elif move_direction == "left":
			if current_direction == "up":
				animation = "back_walk"
			elif current_direction == "down":
				animation = "front_walk"
			elif current_direction == "left":
				rev = true
			else:
				animation = "side_walk"
		elif move_direction == "up":
			if current_direction == "right" or current_direction == "left":
				animation = "side_walk"
			elif current_direction == "down":
				animation = "front_walk"
			else:
				animation = "back_walk"
		elif move_direction == "down":
			if current_direction == "right" or current_direction == "left":
				animation = "side_walk"
			elif current_direction == "up":
				animation = "back_walk"
			else:
				animation = "front_walk"
	else:
		animation = idle
	
	if attack_in_progress == false:
		anim.play(animation)
		
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		_player_stat.health = _player_stat.health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		emit_signal("health_loss")
		print(_player_stat.health)
	

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func player():
	pass
	
func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
		
		if melee_range == true:
			emit_signal("damage_enemy", _player_stat.attack)


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false


func _on_attract_body_entered(body):
	if body.is_in_group("Enemy"):
		body.attack_timer.start()

func _on_attract_body_exited(body):
	if body.is_in_group("Enemy"):
		body.attack_timer.stop()
		body.state = body.SURROUND
		
func _on_enemy_attack_body_entered(body):
	if body.is_in_group("Enemy"):
		body.state = body.HIT
		

func _on_enemy_attack_body_exited(body):
	if body.is_in_group("Enemy"):
		body.state = body.SURROUND
		

func shoot():
	var projectile = PROJECTILE_PATH.instantiate()
	
	get_parent().add_child(projectile)
	projectile.position = $ProjectileDirection/Marker2D.global_position
	projectile.vel = get_global_mouse_position() - projectile.position


func _on_hud_movement_upgrade(): # Current prototype for speed boost when getting upgrade
	speed_boost += 25
	

func _on_hud_attack_upgrade():
	pass # Replace with function body.
	

func _input(event): # Gets player direction based on mouse when there is mouse movement and plays idle animations
	if event is InputEventMouseMotion:
		player_mouse_direction = (global_position - get_global_mouse_position())
		player_mouse_direction.x *= -1
	
		var anim = $AnimatedSprite2D
		
		if player_mouse_direction.y > 0:
			if player_mouse_direction.x / 2 * -1 > player_mouse_direction.y - 20:
				current_direction = "left"
				idle = "side_idle"
				anim.flip_h = true
			elif player_mouse_direction.x / 2 > player_mouse_direction.y - 20:
				current_direction = "right"
				idle = "side_idle"
				anim.flip_h = false
			else:
				current_direction = "up"
				idle = "back_idle"
		elif player_mouse_direction.y < 0:
			if player_mouse_direction.x / 2 < player_mouse_direction.y + 20:
				current_direction = "left"
				idle = "side_idle"
				anim.flip_h = true
			elif player_mouse_direction.x / 2 * -1 < player_mouse_direction.y + 20:
				current_direction = "right"
				idle = "side_idle"
				anim.flip_h = false
			else:
				current_direction = "down"
				idle = "front_idle"
					
		if moving == false and attack_in_progress == false:
			anim.play(idle)


func _on_melee_attack_body_entered(body):
	if body.has_method("enemy"):
		melee_range = true


func _on_melee_attack_body_exited(body):
	if body.has_method("enemy"):
		melee_range = false

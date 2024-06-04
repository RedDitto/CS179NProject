extends CharacterBody2D

signal health_loss
signal damage_enemy
signal upgrade_gained
signal currency_gained

var _player_stats = Global._player_stats
var _player_upgrades = Global._player_upgrades

const PROJECTILE_PATH = preload('res://Scenes/Projectile.tscn')
const fridgePATH = preload('res://Scenes/fridge.tscn')
const diedPATH = preload('res://Scenes/DiedMessage.tscn')
var DashDirection = Vector2.ZERO
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var melee_range = false
var _is_mouse_movement = false
var dashing = false
var can_dash = true
var DashSpeed = 2.3
var attack_in_progress = false
var cheat_death_used = false
var canShoot = true
var diedNode = null

var i_frames = false
var speed_boost = 0
var current_direction = "none"
var move_direction = "none"
var player_mouse_direction = Vector2(0,0)
var moving = false
var idle = "none"
var animation = "none"

var hasRangedWeapon = false
var hasMeleeWeapon = false
var hastp = false
var collision = true
var isPoisoned = false
@onready var particles = $CPUParticles2D
var particlesOn = false
@onready var abilityTimer = $AbilityTimer
var can_bigattack = false
var blockInput = false

func resetHealth():
	_player_stats.health = 100

func _input(event):
	if event.is_action_pressed("lbutton"):
		if diedNode != null && diedNode.restartGame:
			restartGame()
	if blockInput: 
		return
	if event.is_action_pressed("print"):
		print(position)
		collision = !collision
		#particlesOn = !particlesOn
		#can_bigattack = true
		setBigAttack(true)
		particles.emitting = particlesOn
		particles.visible = particlesOn
		_player_stats.health = 1000
		_player_stats.max_health = 1000
		unpoison()
		self.set_collision_layer_value(3,collision)
		self.set_collision_mask_value(1,collision)
		self.set_collision_mask_value(2,collision)
	if event.is_action_pressed("tp"):
		if hastp:
			position = position - (global_position - get_global_mouse_position())
			
func setBigAttack(val):
		can_bigattack = val
		particlesOn = val
		particles.emitting = val
		particles.visible = val
		if val:
			abilityTimer.wait_time = 10
			abilityTimer.start()
		else:
			abilityTimer.stop()
			
			
func _ready():
	$AnimatedSprite2D.play("front_idle")
	$Melee_Attack/Melee_Collision.disabled = true
	$PoisonEffect.visible = false

func _physics_process(delta):
	if blockInput: 
		return
	player_movement(delta)
	enemy_attack()
	_mouse_direction()
	#projectile shooting
	if Input.is_action_just_pressed("shoot_projectile") and !Global._menu_open:
		if (hasRangedWeapon):
			shoot()
	elif Input.is_action_just_pressed("attack") and !Global._menu_open:
		if (hasMeleeWeapon):
			attack()
	$ProjectileDirection.look_at(get_global_mouse_position())
	
	if _player_stats.health <= 0:
		if _player_stats.cheat_death == 1 and !cheat_death_used:
				_player_stats.health = 0.5 * _player_stats.max_health
				cheat_death_used = true
		else:
			player_alive = false #where you would add go back to menu / respawn
			_player_stats.health = 0
			endPlayer()
			#get_tree().reload_current_scene()
			#_player_stats.health = 100
			#_player_stats.max_health = 100
			#print("Y O U   D I E D")
			#self.queue_free()
			
func restartGame():
	get_tree().reload_current_scene()
	_player_stats.health = 100
	_player_stats.max_health = 100
	self.queue_free()
			
func endPlayer():
	visible = false
	blockInput = true
	var died = diedPATH.instantiate()
	died.position = position
	get_parent().add_child(died)
	diedNode = died
	

func player_movement(delta):
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		set_collision_mask_value(2, false)
		$dash_again_timer.start()
	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionX:
		if dashing:
			velocity.x = directionX * (_player_stats.speed + speed_boost)*DashSpeed
		else:
			velocity.x = directionX * _player_stats.speed + speed_boost
	else:
		velocity.x = move_toward(velocity.x, 0, _player_stats.speed + speed_boost)
	if directionY:
		if dashing:
			velocity.y = directionY * (_player_stats.speed + speed_boost)*DashSpeed
		else:
			velocity.y = directionY * _player_stats.speed + speed_boost
	else:
		velocity.y = move_toward(velocity.y, 0, _player_stats.speed + speed_boost)
	if Input.is_action_pressed("ui_right"):
		moving = true
		move_direction = "right"
		play_anim()
	elif Input.is_action_pressed("ui_left"):
		moving = true
		move_direction = "left"
		play_anim()
	elif Input.is_action_pressed("ui_down"):
		moving = true
		move_direction = "down"
		play_anim()
	elif Input.is_action_pressed("ui_up"):
		moving = true
		move_direction = "up"
		play_anim()
	else:
		moving = false
		play_anim()
	
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
			else:
				animation = "side_walk"
		elif move_direction == "left":
			if current_direction == "up":
				animation = "back_walk"
			elif current_direction == "down":
				animation = "front_walk"
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
	if enemy_in_attack_range and enemy_attack_cooldown == true and !dashing:
		_player_stats.health = _player_stats.health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		emit_signal("health_loss")
		print(_player_stats.health)
		$hit.play()
	

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func player():
	pass
	
func poison() :
	isPoisoned = true
	$poison_timer.start()
	$poison_timer.wait_time = .5
	$PoisonEffect.visible = true
	$PoisonDoneTimer.wait_time = 10
	$PoisonDoneTimer.start()
	

func unpoison():
	isPoisoned = false
	$poison_timer.stop()
	$PoisonEffect.visible = false
	$PoisonDoneTimer.stop()
	
	
func attack():
	var dir = current_direction
	
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
		
	$Melee_Attack/Melee_Collision.disabled = false
	
	#if melee_range == true:
		#emit_signal("damage_enemy", _player_stat.attack)

func banana():
	pass

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false
	$Melee_Attack/Melee_Collision.disabled = true


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
	if !canShoot:
		return
	canShoot = false
	$ShootTimer.start()
	var projectile = PROJECTILE_PATH.instantiate()
	
	get_parent().add_child(projectile)
	projectile.position = $ProjectileDirection/Marker2D.global_position
	projectile.vel = get_global_mouse_position() - projectile.position
	projectile.rotation = projectile.vel.angle()
	$gunshot.play()


func _on_hud_movement_upgrade(): # Current prototype for speed boost when getting upgrade
	speed_boost += 25
	

func _on_hud_attack_upgrade():
	pass # Replace with function body.
	

func _mouse_direction(): # Gets player direction based on mouse when there is mouse movement and plays idle animations
	player_mouse_direction = (global_position - get_global_mouse_position())
	player_mouse_direction.x *= -1
	
	var anim = $AnimatedSprite2D
	
	if player_mouse_direction.y > 0:
		if player_mouse_direction.x / 2 * -1 > player_mouse_direction.y - 10:
			current_direction = "left"
			idle = "side_idle"
			anim.flip_h = true
		elif player_mouse_direction.x / 2 > player_mouse_direction.y - 10:
			current_direction = "right"
			idle = "side_idle"
			anim.flip_h = false
		else:
			current_direction = "up"
			idle = "back_idle"
	elif player_mouse_direction.y < 0:
		if player_mouse_direction.x / 2 < player_mouse_direction.y + 0:
			current_direction = "left"
			idle = "side_idle"
			anim.flip_h = true
		elif player_mouse_direction.x / 2 * -1 < player_mouse_direction.y + 0:
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
		body.deal_with_damage(_player_stats.melee_attack * 1 + _player_stats.melee_damage_bonus)

func _on_melee_attack_body_exited(body):
	if body.has_method("enemy"):
		melee_range = false


func _on_currency_gain_currency(amount):
	_player_stats.currency += amount
	emit_signal("currency_gained")


func _on_dash_timer_timeout():
	dashing = false
	set_collision_mask_value(2, true)

func _on_dash_again_timer_timeout():
	can_dash = true
	
func pick_up_tp():
	hastp = true




func _on_picked_up_weapon_ranged(sprite):
	hasRangedWeapon = true


func _on_picked_up_weapon_melee(sprite):
	hasMeleeWeapon = true

func deal_with_damage(damage):
	#print('PLAYER TAKES GROUND POUND DAMAGE')
	if enemy_attack_cooldown and !dashing:
		_player_stats.health = _player_stats.health - damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		emit_signal("health_loss")
		print('ground pound hit! player health = ',_player_stats.health)
		$hit.play()
	pass



func _on_poison_timer_timeout():
	_player_stats.health = _player_stats.health - 1
	


func _on_ability_timer_timeout():
	setBigAttack(false)


func _on_big_attack_body_entered(body):
	if body.has_method("poison") && can_bigattack:
		body.poison()
	#pass
		


func _on_poison_done_timer_timeout():
	unpoison()


func _on_shoot_timer_timeout():
	canShoot = true
	$ShootTimer.stop()

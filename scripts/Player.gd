extends CharacterBody2D

const PROJECTILE_PATH = preload('res://Scenes/Projectile.tscn')

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 1000
var player_alive = true

var attack_in_progress = false

const SPEED = 100
var current_direction = "none"


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	if health <= 0:
		player_alive = false #where you would add go back to menu / respawn
		health = 0
		print("Y O U   D I E D")
		self.queue_free()
	
	#projectile shooting
	if Input.is_action_just_pressed("shoot_projectile"):
		shoot()
	$ProjectileDirection.look_at(get_global_mouse_position())
	

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		play_anim(1)
		current_direction = "left"
		velocity.x = -SPEED
		velocity.y = 0 
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")		
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("back_idle")
			

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true
		


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		
		print(health)
	

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

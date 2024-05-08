extends CharacterBody2D

signal health_loss

@export var _enemy_stat : Enemy_Stats

var player_chase = false
var player = null
var player_in_attack_zone = false
var can_take_damage = true
var alive = true
var death_finished = false

func _physics_process(delta):
	#deal_with_damage();
	if alive:
		if player_chase:
			#position += (player.position - position) / speed
			var direction = (player.position - position).normalized()
			var desired_velocity = direction * _enemy_stat.speed
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
			move_and_slide()
			$AnimatedSprite2D.play("walk")
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			
			
			#move_and_collide(Vector2(0,0))
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if death_finished == false:
			death_finished = true
			$AnimatedSprite2D.play("death")
			$death_cooldown.start()
			
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_zone = false

func deal_with_damage(damage):
	if can_take_damage == true:
		_enemy_stat.health = _enemy_stat.health - 20
		$take_damage_cooldown.start()
		can_take_damage = false
		print("slime health = ", _enemy_stat.health)
		emit_signal("health_loss", _enemy_stat.health)
		if _enemy_stat.health <= 0:
			alive = false
			#self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true


func _on_death_cooldown_timeout():
	self.queue_free()

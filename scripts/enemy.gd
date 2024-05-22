extends CharacterBody2D

signal health_loss

@export var _enemy_stats : Enemy_Stats

var currency_drop = preload("res://Scenes/currency.tscn")

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
			var desired_velocity = direction * _enemy_stats.speed
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
			var currency = currency_drop.instantiate()
			get_parent().add_child(currency)
			currency.position = self.position
			
			
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
		print("In body!")


func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_zone = false

func deal_with_damage(damage):
	if can_take_damage == true:
		if _enemy_stats.health - damage < 0:
			_enemy_stats.health = 0
		else:
			_enemy_stats.health = _enemy_stats.health - damage
		$take_damage_cooldown.start()
		can_take_damage = false
		print("slime health = ", _enemy_stats.health)
		emit_signal("health_loss", _enemy_stats.health)
		if _enemy_stats.health <= 0:
			alive = false
			#self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true


func _on_death_cooldown_timeout():
	self.queue_free()

extends CharacterBody2D


var direction  = Vector2.LEFT 
var speed  = 150
var damage = 10

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _player_stats = Global._player_stats


func _physics_process(delta):
	move_and_collide(direction * speed * delta)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AudioStreamPlayer2D.play()
		_player_stats.health -= 10
		queue_free()
	elif(not body.is_in_group("ranged_enemy")):
		queue_free() 
	

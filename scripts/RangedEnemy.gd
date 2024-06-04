extends CharacterBody2D

var health = 800
var max_health = 800
var speed = 70
var range = 70
var player_chase = false
var player = null
var isPoisoned = false
var allow_shoot = true
var in_range = false

var projectile = preload("res://Scenes/Enemy_projectile.tscn")

func _ready():
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))

func _physics_process(delta):
	if player_chase:
		var dist = (player.position - self.position).length()
		self.velocity = ((player.position - self.position).normalized() * speed) if (dist > range) else Vector2(0,0)
		move_and_slide()
	
	if(allow_shoot and player != null):
		shoot_bullet(player)
		allow_shoot = false;

		
	
func deal_with_damage(amt):
	health = health - amt
	if health <= 0:
		self.queue_free()
	
func enemy():
	pass
	
	

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		print("EEE")
		player = body
		player_chase = true
		in_range = true
		

		
		
func poison() :
	isPoisoned = true
	$poison_timer.wait_time = 1
	$poison_timer.start()



func _on_poison_timer_timeout():
	deal_with_damage(max_health/7)

func shoot_bullet(player):
	var proj = projectile.instantiate()
	get_tree().get_root().add_child(proj)
	proj.global_position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.global_rotation =proj.direction.angle() + PI / 2.0



func _on_shoot_timer_timeout():
	allow_shoot = true

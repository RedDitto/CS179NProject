extends CharacterBody2D

var health = 100
var max_health = 100
var speed = 40
var range = 70
var player_chase = false
var player = null
var isPoisoned = false
var allow_shoot = true
var in_range = false
var alive = true
var flee = false
var in_knockback = false

@onready var navigation_agent_2d = $Navigation/NavigationAgent2D
@export var target: Node2D = null
@onready var health_bar = $Health_Bar
@onready var hit_animation_player = $Hit_AnimationPlayer


var projectile = preload("res://Scenes/Enemy_projectile.tscn")

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
				
			var current_agent_position = global_position
			var next_path_position = navigation_agent_2d.get_next_path_position()
			var new_velocity = current_agent_position.direction_to(next_path_position) * speed
			
			
			if flee:
				new_velocity = -new_velocity
			
			_on_navigation_agent_2d_velocity_computed(new_velocity)
			
			if !in_range or (in_range and flee):
				move_and_slide()
		
	
	if(allow_shoot and player != null):
		shoot_bullet(player)
		allow_shoot = false;
	
		
	
func deal_with_damage(amt):
	health = health - amt
	if health <= 0:
		alive = false
		self.queue_free()
	hit_animation_player.play("hit")
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
		health_bar.visible = true
		
		
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

func _on_timer_timeout():
	if player != null:
		navigation_agent_2d.target_position = player.global_position

func _on_shoot_timer_timeout():
	allow_shoot = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_stop_distance_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true


func _on_stop_distance_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false


func _on_flee_distance_body_entered(body):
	if body.is_in_group("Player"):
		flee = true


func _on_flee_distance_body_exited(body):
	if body.is_in_group("Player"):
		flee = false

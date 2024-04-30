extends CharacterBody2D

@export var max_speed = 350
@export var steer_force = 0.1
@export var look_ahead = 100
@export var num_rays = 8

var player_chase = false
var player = null


#context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO
#velocity is built in
var acceleration = Vector2.ZERO

func _ready():
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func _physics_process(delta):
	pass
	
func set_interest():
	if player_chase:
		var direction = (player.position - position).normalized()
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(direction)
			interest[i] = max(0, d)
	
func set_danger():
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(position,
		position + ray_directions[i].rotated(rotation) * look_ahead)
		danger[i] = 1.0 if result else 0.0
			
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = false
		player_chase = false

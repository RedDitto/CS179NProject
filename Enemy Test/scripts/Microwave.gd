extends CharacterBody2D


const SPEED = 50
var player_in_range = false
var player = null
var randomnum
var target

@onready var attack_timer = $attack_timer

enum {
	SURROUND, 
	ATTACK, 
	HIT
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	randomnum = rng.randf()
	

func _physics_process(delta):
	match state:
		SURROUND:
			if player_in_range:
				move(get_circle_position(randomnum), delta)
				$AnimatedSprite2D.play("walk")
		ATTACK:
			if player_in_range:
				move(player.position, delta)
				$AnimatedSprite2D.play("walk")
		
		HIT:
			if player_in_range:
				move(player.position, delta)
				$AnimatedSprite2D.play("attack")
				
func move(target, delta):
	var direction = (target - position).normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_center = player.position
	var radius = 40
	var angle = random * PI * 2
	var x = kill_circle_center.x + cos(angle) * radius
	var y = kill_circle_center.y + sin(angle) * radius
	
	return Vector2(x, y)

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_in_range = true
		


func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_in_range = false


func _on_attack_timer_timeout():
	state = ATTACK

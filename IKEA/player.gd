extends Area2D

signal hit
@export var NormalSpeed = 200 # How fast the player will move (pixels/sec).
@export var DashSpeed = 1000
var screen_size # Size of the game window.
const DASH_TIME = 1
var dash_acc = 0
var dashing = false
var dash_pressed = 0
var dashlength = .1
@onready var dash = $Dash
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("dash"):
		dash.start_dash(dashlength)
	var speed = DashSpeed if dash.is_dashing() else NormalSpeed
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

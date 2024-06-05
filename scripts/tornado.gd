extends CharacterBody2D

var direction  = Vector2.LEFT 
var speed  = 60
var damage = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_and_collide(direction * speed * delta)
	


func _on_tornado_hurtbox_body_entered(body):
	if body.is_in_group("Player"):
		body.deal_with_damage(10)
		queue_free()
	else:
		queue_free()

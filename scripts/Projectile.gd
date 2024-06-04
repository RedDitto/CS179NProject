extends CharacterBody2D


const SPEED = 450.0
var vel = Vector2(0, 1)



func _physics_process(delta):
	var collistion_info = move_and_collide(vel.normalized()  * delta * SPEED)
	


func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		queue_free()
	if body.has_method("enemy"):
		body.deal_with_damage(20)
		print("Hit Ranged!!!")

extends CharacterBody2D

var health = 400
var max_health = 400
var speed = 70
var range = 40
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		var dist = (player.position - self.position).length()
		self.velocity = ((player.position - self.position).normalized() * speed) if (dist > range) else Vector2(0,0)
		move_and_slide()
		
	
func deal_with_damage(amt):
	health = health - amt
	if health <= 0:
		self.queue_free()
	
func enemy():
	pass
	
	


func _on_detection_area_body_exited(body):
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true


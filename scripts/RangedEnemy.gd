extends CharacterBody2D

var health = 800
var max_health = 800
var speed = 70
var range = 70
var player_chase = false
var player = null
var isPoisoned = false

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
		print("EEE")
		player = body
		player_chase = true
		
		
func poison() :
	isPoisoned = true
	$poison_timer.wait_time = 1
	$poison_timer.start()



func _on_poison_timer_timeout():
	deal_with_damage(max_health/7)

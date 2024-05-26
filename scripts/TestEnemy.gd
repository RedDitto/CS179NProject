extends CharacterBody2D

var health = 100


func _physics_process(delta):
	pass
	
func deal_with_damage(amt):
	health = health - amt
	if health <= 0:
		self.queue_free()
	
func enemy():
	pass

extends Node2D

signal picked_up_item



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_area_2d_body_entered(body):
	
	if body.has_method("player"):
		emit_signal("picked_up_item", $Sprite2D.texture)
		
		queue_free()
		
		
		

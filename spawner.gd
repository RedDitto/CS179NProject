extends CharacterBody2D

const fridgePATH = preload('res://Scenes/fridge.tscn')
func spawn():
	pass


func _on_collision_shape_2d_child_entered_tree(node):
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	print("EE")
	if(body.has_method("banana")):
		var aaa = fridgePATH.instantiate()
		aaa.position = Vector2(position.x, position.y)
		get_parent().add_child(aaa)

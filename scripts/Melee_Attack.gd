extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_direction = global_position - get_global_mouse_position()
		var degree = mouse_direction.angle() - 4.7
		#get_parent().mouseAngle = degree;
		rotation = degree

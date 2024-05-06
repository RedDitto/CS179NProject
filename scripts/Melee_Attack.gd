extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_direction = global_position - get_global_mouse_position()
		var degree = mouse_direction.angle() - 4.7
		
		rotation = degree

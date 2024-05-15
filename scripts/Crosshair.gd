extends Control

var mouse_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_position = get_local_mouse_position()
	$TextureRect.position.y = mouse_position.y
	$TextureRect.position.x = mouse_position.x - 10

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale.x < 1.1:
		scale.x += delta * .3
		scale.y += delta * .3
	else:
		get_children()[0].visible = true
		get_parent().restartGame = true

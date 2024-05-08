extends StaticBody2D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func open(): 
	animation_player.play("new_animation")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

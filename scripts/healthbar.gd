extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = get_parent().max_health
	value = get_parent().health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = get_parent().health

extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	value = get_parent()._enemy_stat.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_health_loss(health):
	value = health

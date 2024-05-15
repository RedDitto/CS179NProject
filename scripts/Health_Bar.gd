extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = get_parent()._player_stat.max_health
	value = get_parent()._player_stat.health

func _update():
	value = get_parent()._player_stat.health

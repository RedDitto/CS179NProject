extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "HP: " + str(get_parent()._player_stat.health)

func _on_hud_health_change():
	text = "HP: " + str(get_parent()._player_stat.health)

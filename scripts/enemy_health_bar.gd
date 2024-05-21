extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	value = get_parent()._enemy_stats.health

func _on_fridge_health_loss(health):
	value = health

func _on_oscillating_fan_health_loss(health):
	value = health


func _on_enemy_health_loss(health):
	value = health

extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Currency: " + str(get_parent()._player_stat.currency)

func _process(delta):
	text = "Currency: " + str(get_parent()._player_stat.currency)

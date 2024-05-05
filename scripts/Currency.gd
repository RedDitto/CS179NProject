extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Currency: " + str(get_parent()._player_stat.currency)

func _on_currency_test_timeout():
	get_parent()._player_stat.currency += 10
	text = "Currency: " + str(get_parent()._player_stat.currency)

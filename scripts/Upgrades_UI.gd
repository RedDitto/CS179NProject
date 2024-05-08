extends Label

signal movement_upgrade
signal attack_upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _update():
	text = "Upgrade:"	
	if get_parent()._player_stat.upgrades[0][1] > 0:
		text += "\n" + get_parent()._player_stat.upgrades[0][0]
		for i in range(get_parent()._player_stat.upgrades[0][1]):
			text += "+"
	if get_parent()._player_stat.upgrades[1][1] > 0:
		text += "\n" + get_parent()._player_stat.upgrades[1][0]
		for i in range(get_parent()._player_stat.upgrades[1][1]):
			text += "+"

extends Label

signal movement_upgrade
signal attack_upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _update():
	text = "Upgrades:"
	for i in Global._player_upgrades.upgrades:
		if i[1] > 0:
			text += "\n" + i[0]
		for j in range(i[1]):
			text += "+"

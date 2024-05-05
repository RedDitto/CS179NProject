extends Label

signal movement_upgrade
signal attack_upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_upgrade_test_timeout():
	var random_number = randi() % 2
	if (random_number == 0 and get_parent()._player_stat.upgrades[0][1] < 4):
		get_parent()._player_stat.upgrades[0][1] += 1
		emit_signal("movement_upgrade")
	elif (random_number == 1 and get_parent()._player_stat.upgrades[1][1] < 4):
		get_parent()._player_stat.upgrades[1][1] += 1
		emit_signal("attack_upgrade")
		
	text = "Upgrade:"	
	if get_parent()._player_stat.upgrades[0][1] > 0:
		text += "\n" + get_parent()._player_stat.upgrades[0][0]
		for i in range(get_parent()._player_stat.upgrades[0][1]):
			text += "+"
	if get_parent()._player_stat.upgrades[1][1] > 0:
		text += "\n" + get_parent()._player_stat.upgrades[1][0]
		for i in range(get_parent()._player_stat.upgrades[1][1]):
			text += "+"

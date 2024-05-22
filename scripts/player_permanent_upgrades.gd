extends Resource

class_name Player_Permanent_Upgrades

var upgrades = [
	["Starting Health", 0, 10, 100],
	["Cheat Death", 0, 1, 5000]
]

var is_max = [false, false]

func _upgrade_increase(choice, _player_stats):
	if upgrades[choice][0] == "Starting Health":
		if upgrades[choice][1] < 10:
			upgrades[choice][1] += 1
			_player_stats.max_health += 10
			_player_stats.health = _player_stats.max_health
			_player_stats.bank -= upgrades[0][3]
			upgrades[choice][3] += 20
			if upgrades[0][1] == upgrades[0][2]:
				is_max[0] = true
	elif upgrades[choice][0] == "Cheat Death":
		if upgrades[choice][1] < 1:
			upgrades[choice][1] += 1
			_player_stats.cheat_death += 1
			_player_stats.bank -= upgrades[1][3]
			if upgrades[1][1] == upgrades[1][2]:
				is_max[1] = true

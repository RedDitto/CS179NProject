extends Resource

class_name Player_Upgrades

var upgrades = [
	["Increased Movement Speed", 0, 10],
	["Increased Ranged Damage", 0, 5],
	["Increased Melee Damage", 0, 5]
]

var descriptions = [
	"Player movement speed is increased by " + str((upgrades[0][1] + 1) * upgrades[2][2]) + "%.",
	"Player ranged damage is increased by " + str((upgrades[2][1] + 1) * upgrades[1][2]) + "%.",
	"Player melee damage is increased by " + str((upgrades[2][1] + 1) * upgrades[2][2]) + "%."
]


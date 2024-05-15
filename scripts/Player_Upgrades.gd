extends Resource

class_name Player_Upgrades

var upgrades = [
	["Increased Movement Speed", 0, 10],
	["Increased Attack Speed", 0, 10],
	["Increased Damage", 0, 10]
]

var descriptions = [
	"Player movement speed is increased by " + str((upgrades[0][1] + 1) * upgrades[2][2]) + "%.",
	"Player attack speed is increased by " + str((upgrades[1][1] + 1) * upgrades[2][2]) + "%.",
	"Player damage is increased by " + str((upgrades[2][1] + 1) * upgrades[2][2]) + "%."
]


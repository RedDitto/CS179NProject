extends CanvasLayer

signal is_visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _open_menu(rn1, rn2):
	if rn1 != null:
		$Upgrade1_Button/Upgrade1.text = Global._player_upgrades.upgrades[rn1][0]
		$Upgrade1_Button/Upgrade1_Description.text = Global._player_upgrades.descriptions[rn1]
	if rn2 != null:
		$Upgrade2_Button/Upgrade2.text = Global._player_upgrades.upgrades[rn2][0]
		$Upgrade2_Button/Upgrade2_Description.text = Global._player_upgrades.descriptions[rn2]
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("is_visible")

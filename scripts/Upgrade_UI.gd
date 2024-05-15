extends CanvasLayer

signal is_visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_upgrade_open_menu(rn1, rn2):
	$Upgrade1_Button/Upgrade1.text = Global._player_upgrades.upgrades[rn1][0]
	$Upgrade1_Button/Upgrade1_Description.text = Global._player_upgrades.descriptions[rn1]
	$Upgrade2_Button/Upgrade2.text = Global._player_upgrades.upgrades[rn2][0]
	$Upgrade2_Button/Upgrade2_Description.text = Global._player_upgrades.descriptions[rn2]
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("is_visible")

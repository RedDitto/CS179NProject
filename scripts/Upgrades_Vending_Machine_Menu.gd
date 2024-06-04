extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	$Upgrade1_Label/Button1.disabled = true
	$Upgrade2_Label/Button2.disabled = true

func _open_menu():
	self.visible = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Upgrade1_Label/Button1.disabled = false
	$Upgrade2_Label/Button2.disabled = false
	$Upgrade1_Label.text = get_parent()._player_permanent_upgrades.upgrades[0][0] + ": " + str(Global._player_stats.health)
	$Upgrade1_Label/Rank.text = str(get_parent()._player_permanent_upgrades.upgrades[0][1])
	$Upgrade1_Label/Cost.text = str(get_parent()._player_permanent_upgrades.upgrades[0][3])
	$Upgrade2_Label.text = get_parent()._player_permanent_upgrades.upgrades[1][0] + ":"
	$Upgrade2_Label/Rank.text = str(get_parent()._player_permanent_upgrades.upgrades[1][1])
	$Upgrade2_Label/Cost.text = str(get_parent()._player_permanent_upgrades.upgrades[1][3])
	$Bank.text = "Bank: $" + str(Global._player_stats.bank)

func _update_upgrade1():
	$Upgrade1_Label.text = str(get_parent()._player_permanent_upgrades.upgrades[0][0]) + ": " + str(Global._player_stats.health)
	if get_parent()._player_permanent_upgrades.is_max[0]:
		$Upgrade1_Label/Rank.text = "MAX"
		$Upgrade1_Label/Cost.text = ""
	else:
		$Upgrade1_Label/Rank.text = str(get_parent()._player_permanent_upgrades.upgrades[0][1])
		$Upgrade1_Label/Cost.text = str(get_parent()._player_permanent_upgrades.upgrades[0][3])
	$Bank.text = "Bank: $" + str(Global._player_stats.bank)
	

func _update_upgrade2():
	$Upgrade2_Label.text = str(get_parent()._player_permanent_upgrades.upgrades[1][0])
	if get_parent()._player_permanent_upgrades.is_max[1]:
		$Upgrade2_Label/Rank.text = "MAX"
		$Upgrade2_Label/Cost.text = ""
	else:
		$Upgrade2_Label/Rank.text = str(get_parent()._player_permanent_upgrades.upgrades[1][1])
		$Upgrade2_Label/Cost.text = str(get_parent()._player_permanent_upgrades.upgrades[1][3])
	$Bank.text = "Bank: $" + str(Global._player_stats.bank)

func _on_button1_pressed():
	if !get_parent()._player_permanent_upgrades.is_max[0] and Global._player_stats.bank >= get_parent()._player_permanent_upgrades.upgrades[0][3]:
		get_parent()._player_permanent_upgrades._upgrade_increase(0, Global._player_stats)
		_update_upgrade1()

func _on_button2_pressed():
	print("button 2 pressed")
	if !get_parent()._player_permanent_upgrades.is_max[1] and Global._player_stats.bank >= get_parent()._player_permanent_upgrades.upgrades[1][3]:
		get_parent()._player_permanent_upgrades._upgrade_increase(1, Global._player_stats)
		_update_upgrade2()


func _on_close_button_pressed():
	Global._menu_open = false
	self.visible = false
	$Upgrade1_Label/Button1.disabled = true
	$Upgrade2_Label/Button2.disabled = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

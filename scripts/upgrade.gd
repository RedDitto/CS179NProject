extends Node2D

signal gain_upgrade

var _player_upgrades = Global._player_upgrades
var _player_stats = Global._player_stats
var player_in_area = false
var button_pressed = false
var random_number1
var random_number2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.visible = true
	$Upgrade_UI.visible = false

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_in_area = true

func _on_area_2d_body_exited(body):
	player_in_area = false
	
func _input(event):
	if player_in_area == true:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_E and !button_pressed:
				button_pressed = true
				var count = 0
				for i in Global._player_upgrades.upgrades:
					if i[1] < 4:
						count += 1
				random_number1 = randi_range(0,2)
				random_number2 = randi_range(0,2)
				if count > 0:
					while Global._player_upgrades.upgrades[random_number1][1] == 4:
						random_number1 = randi_range(0,2)
				if count > 1:
					while random_number1 == random_number2 or Global._player_upgrades.upgrades[random_number2][1] == 4:
						random_number2 = randi_range(0,2)
					$Upgrade_UI._open_menu(random_number1, random_number2)
				else:
					$Upgrade_UI._open_menu(random_number1, null)
				Global._menu_open = true


func _on_upgrade_button_upgrade_chosen(choice):
	if choice == 1:
		choice = random_number1
	else:
		choice = random_number2
	
	if (choice == 0 and _player_upgrades.upgrades[0][1] < 4): #Movement Speed
		_player_stats.speed_boost += _player_upgrades.upgrades[0][2]
		_player_upgrades.upgrades[choice][1] += 1
	elif (choice == 1 and _player_upgrades.upgrades[1][1] < 4): #Ranged Damage
		_player_stats.ranged_damage_bonus += _player_upgrades.upgrades[1][2]
		_player_upgrades.upgrades[choice][1] += 1
	elif (choice == 2 and _player_upgrades.upgrades[2][1] < 4): #Melee Damage
		_player_stats.melee_damage_bonus += _player_upgrades.upgrades[2][2]
		_player_upgrades.upgrades[choice][1] += 1
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()

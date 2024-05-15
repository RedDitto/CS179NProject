extends Node2D

signal gain_upgrade
signal open_menu

var _player_upgrades = Global._player_upgrades
var player_in_area = false
var random_number1
var random_number2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.visible = true
	$Upgrade_UI.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_in_area = true

func _on_area_2d_body_exited(body):
	player_in_area = false
	
func _input(event):
	if player_in_area == true:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_E:
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
					emit_signal("open_menu", random_number1, random_number2)
				else:
					emit_signal("open_menu", random_number1, null)
				Global._menu_open = true


func _on_upgrade_button_upgrade_chosen(choice):
	if choice == 1:
		_player_upgrades.upgrades[random_number1][1] += 1
		emit_signal("gain_upgrade", random_number1)
	else:
		_player_upgrades.upgrades[random_number2][1] += 1
		emit_signal("gain_upgrade", random_number2)
	self.queue_free()

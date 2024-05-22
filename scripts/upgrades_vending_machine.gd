extends StaticBody2D

var player_in_area = false
var _player_permanent_upgrades = Global._player_permanent_upgrades

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		print("Player in area!")

func _on_area_2d_body_exited(body):
	player_in_area = false
	
func _input(event):
	if player_in_area == true:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_E:
				$Menu._open_menu()
				print("Opening Menu")
				Global._menu_open = true

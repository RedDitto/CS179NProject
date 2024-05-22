extends CanvasLayer

var _player_stat = Global._player_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_health_loss():
	$HP_Label._update()
	$"Health Bar"._update()

func _on_player_currency_gained():
	$Currency_Label._update()

func _on_player_upgrade_gained():
	$Upgrades_Label._update()


func _on_picked_up_weapon_melee(texture):
	get_node("WeaponDisplayMelee").texture = ResourceLoader.load(texture.get_load_path())


func _on_picked_up_weapon_ranged(texture):
	get_node("WeaponDisplayRanged").texture = ResourceLoader.load(texture.get_load_path())

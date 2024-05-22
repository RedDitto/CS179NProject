extends CanvasLayer

var _player_stat = Global._player_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	$Health_Bar.max_value = _player_stat.max_health
	$Health_Bar.value = _player_stat.health
	
func _process(delta):
	$Health_Bar.max_value = _player_stat.max_health
	$Currency_Label.text = "Currency: $" + str(_player_stat.currency)
	$HP_Label.text = "HP: " + str(_player_stat.health)
	$"Health_Bar".value = _player_stat.health

func _on_player_currency_gained():
	$Currency_Label._update()

func _on_player_upgrade_gained():
	$Upgrades_Label._update()


func _on_picked_up_weapon_melee(texture):
	get_node("WeaponDisplayMelee").texture = ResourceLoader.load(texture.get_load_path())


func _on_picked_up_weapon_ranged(texture):
	get_node("WeaponDisplayRanged").texture = ResourceLoader.load(texture.get_load_path())

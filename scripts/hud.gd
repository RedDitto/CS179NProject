extends CanvasLayer

signal health_change
signal movement_upgrade
signal attack_upgrade

var _player_stat = Global._player_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_health_loss():
	emit_signal("health_change")

func _on_upgrades_attack_upgrade():
	emit_signal("attack_upgrade")

func _on_upgrades_movement_upgrade():
	emit_signal("movement_upgrade")


func _on_player_upgrade_gained():
	get_node("Upgrades_UI")._update()


func _on_player_currency_gained():
	get_node("Currency_UI")._update()


func _on_upgrade_gain_upgrade():
	$Upgrades_UI._update()

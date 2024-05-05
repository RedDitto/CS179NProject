extends CanvasLayer

signal health_change
signal movement_upgrade
signal attack_upgrade

@export var _player_stat : Player_Stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_health_loss():
	emit_signal("health_change")

func _on_upgrades_attack_upgrade():
	emit_signal("attack_upgrade")

func _on_upgrades_movement_upgrade():
	emit_signal("movement_upgrade")

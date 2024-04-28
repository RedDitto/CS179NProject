extends Node2D

signal health_depleted
signal currency_increase
signal new_upgrade

var upgrade_list = ["Increased Movement Speed I", "Increased Attack Speed I", "Increased Movement Speed II", "Increased Attack Speed II"]

var max_health = 100
var current_health = max_health
var currency = 0
var upgrades = []
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_currency_timer_timeout():
	currency += 10
	emit_signal("currency_increase", currency)


func _on_health_timer_timeout():
	if current_health > 0:
		current_health -= 25
		emit_signal("health_depleted", current_health)


func _on_upgrade_timer_timeout():
	if count < 4:
		upgrades.append(upgrade_list[count])
		count += 1
		emit_signal("new_upgrade", upgrades)

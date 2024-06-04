extends Node

var player_current_attack = false
var _player_stats = preload("res://scripts/Player_Stats.tres")
var _player_upgrades = preload("res://scripts/Player_Upgrades.tres")
var _player_permanent_upgrades = preload("res://scripts/Player_Permanent_Upgrades.tres")
var _menu_open = false

var numruns = 0
var currentrun = 0
var displaycurrentrun = "n/a"
var bestrun = 100000000
var displaybestrun = "n/a"
var numwins = 0
var fridgesKilled = 0
var microwavesKilled = 0
var fansKilled = 0
var rangedGuysKilled = 0
func _ready():
	load_data()
	_player_stats.health = _player_stats.max_health
	
func save_data():
	var file = FileAccess.open("res://save_file.json", FileAccess.WRITE)
	var save_data = {
		"max_health": _player_stats.max_health,
		"cheat_death": _player_stats.cheat_death,
		"bank": _player_stats.bank,
		"upgrades": _player_permanent_upgrades.upgrades,
		"numruns": numruns,
		"numwins": numwins,
		"displaybestrun": displaybestrun,
		"bestrun": bestrun,
		"fridgesKilled": fridgesKilled,
		"microwavesKilled": microwavesKilled,
		"fansKilled": fansKilled,
		"rangedGuysKilled": rangedGuysKilled
	}
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	
func load_data():
	var file = FileAccess.open("res://save_file.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var data = JSON.parse_string(json_string)
	if data.size() > 0:
		_player_stats.max_health = data["max_health"]
		_player_stats.cheat_death = data["cheat_death"]
		_player_stats.bank = data["bank"]
		_player_permanent_upgrades.upgrades = data["upgrades"]
		numruns = data["numruns"]
		displaybestrun = data["displaybestrun"]
		bestrun = data["bestrun"]
		numwins = data["numwins"]
		fridgesKilled = data["fridgesKilled"]
		microwavesKilled = data["microwavesKilled"]
		fansKilled = data["fansKilled"]
		rangedGuysKilled = data["rangedGuysKilled"]
	file.close()

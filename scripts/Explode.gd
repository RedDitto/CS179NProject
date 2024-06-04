extends CPUParticles2D

const winPATH = preload('res://Scenes/WinMessage.tscn')
var winmsg = null
var _player_stats = Global._player_stats
# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	get_parent().get_node("Timer").start()
	
	
func _input(event):
	if event.is_action_pressed("lbutton"):
		if winmsg != null && winmsg.restartGame:
			_player_stats.bank += _player_stats.currency # transfer currency to bank when died
			_player_stats.currency = 0
			_player_stats.health = _player_stats.max_health
			Global.save_data()
			get_tree().change_scene_to_file("res://Scenes/menu.tscn");

			
			


func _on_timer_timeout():
	if get_parent().name == "BossExplosion":
		winmsg = winPATH.instantiate()
		winmsg.position = position
		#print(winmsg.position)
		get_parent().add_child(winmsg)
		self.visible = false
		get_parent().get_node("Timer").stop()
	else:
		self.queue_free()

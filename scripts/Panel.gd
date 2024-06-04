extends Panel
var time: float = 0.0
var minutes = 0
var seconds = 0
var mseconds = 0
#var paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


func _physics_process(delta):
	#if Global._player_stats.health != 100: 
		#return
	if Global.pauseTimer == true:
		return
	else:
		#print(paused)
		time += delta
		mseconds = fmod(time,1) * 100
		seconds = fmod(time,60) 
		minutes = fmod(time, 3600) / 60
		$Minutes.text = "%02d:" % minutes
		$Seconds.text = "%02d:" % seconds
		$Milliseconds.text = "%02d" % mseconds
		Global.currentrun = time
		Global.displaycurrentrun = str("%02d:" % minutes) + " " + str("%02d:" % seconds) + " " + str("%02d" % mseconds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if paused: 
		#return
	#print(paused)
	#time += delta
	#mseconds = fmod(time,1) * 100
	#seconds = fmod(time,60) 
	#minutes = fmod(time, 3600) / 60
	#$Minutes.text = "%02d:" % minutes
	#$Seconds.text = "%02d:" % seconds
	#$Milliseconds.text = "%02d" % mseconds
	#Global.currentrun = time
	#Global.displaycurrentrun = str("%02d:" % minutes) + " " + str("%02d:" % seconds) + " " + str("%02d" % mseconds)
func _stop():
	print("STOPPEEED")
	#paused = true
	set_process(false)
	if Global.currentrun < Global.bestrun:
		Global.displaybestrun = Global.displaycurrentrun
		Global.bestrun = Global.currentrun
	Global.save_data()
	

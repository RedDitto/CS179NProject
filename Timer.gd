extends Label

var time = 0

func _process(delta):
	time += delta
	
	var secs = fmod(time, 60)
	
	var time_passed = "%02d" % [secs]
	text = time_passed

extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Upgrades:"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_test_player_new_upgrade(upgrades):
	text = "Upgrades:"
	for i in upgrades:
		text += "\n" + i

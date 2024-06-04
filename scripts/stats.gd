extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureRect/VBoxContainer/pb.text = "Fastest Run: " + Global.displaybestrun
	$TextureRect/VBoxContainer/numwins.text = "Wins: " + str(Global.numwins)
	$TextureRect/VBoxContainer/numruns.text = "Runs: " + str(Global.numruns)
	$TextureRect/VBoxContainer/fridgeskilled.text = "Fridges Killed: " + str(Global.fridgesKilled)
	$TextureRect/VBoxContainer/rangedkilled.text = "Ranged Guys Killed: " + str(Global.rangedGuysKilled)
	$TextureRect/VBoxContainer/fanskilled.text = "Fans Killed: " + str(Global.fansKilled)
	$TextureRect/VBoxContainer/microwaveskilled.text = "Microwaves Killed: " + str(Global.microwavesKilled)


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn");

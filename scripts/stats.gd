extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureRect/VBoxContainer/pb.text = "Fastest Run: " + Global.displaybestrun
	$TextureRect/VBoxContainer/numwins.text = "Number of Wins: " + str(Global.numwins)
	$TextureRect/VBoxContainer/numruns.text = "Number of Runs: " + str(Global.numruns)


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn");

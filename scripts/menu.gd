extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Global.mode = 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn");


func _on_button_3_pressed():
	get_tree().quit();


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes//credit.tscn");



func _on_button_4_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn");

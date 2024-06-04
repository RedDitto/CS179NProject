extends Node2D

var coinpath = preload("res://Scenes/bouncycoin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn");
	
	
func _input(ev):
	if ev is InputEventMouseButton and ev.pressed:
		var pos = ev.position
		var coin = coinpath.instantiate()
		coin.position = pos
		get_parent().add_child(coin)
		
	

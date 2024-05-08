extends Node2D

signal gain_upgrade

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area == true:
		if Input.is_action_just_pressed("Use"):
			var random_number = randi() % 2
			emit_signal("gain_upgrade", random_number)
			print("Got an upgrade!")

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_area_2d_body_exited(body):
	player_in_area = false

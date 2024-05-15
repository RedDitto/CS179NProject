extends TextureButton

signal upgrade_chosen

# Called when the node enters the scene tree for the first time.
func _ready():
	self.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Use"):
		get_tree().paused = false


func _on_upgrade_ui_is_visible():
	self.disabled = false

func _on_button_pressed():
	Global._menu_open = false
	print("Button pressed.")
	get_parent().queue_free()
	emit_signal("upgrade_chosen", 1)

extends Node2D


# Called when the node enters the scene tree for the first time.
var p = null
var s = null
@onready var vars = get_node("/root/MenuVars")

func _ready():
	p = $PlayerSprite
	s = $FridgeSprite
	p.play("run")
	s.play("run")
	p.position = vars.p1
	s.position = vars.p2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if p != null:
		upd(delta,p)
		upd(delta,s)
		vars.p1 = p.position
		vars.p2 = s.position 
	
	
func upd(delta, t):
	t.position.x += 100  * delta
	if t.position.x > 600:
		t.position.x = -200

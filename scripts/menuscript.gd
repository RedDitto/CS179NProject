extends Node2D


# Called when the node enters the scene tree for the first time.
var p = null
var s = null
var dir = 1
var splat = false
@onready var vars = get_node("/root/MenuVars")


func _input(ev):
	if ev is InputEventMouseButton and ev.pressed:
		var pos = ev.position
		if inrect(pos,s.position.x-50,s.position.y-50, 100,100):
			dir *= -1
		if inrect(pos,p.position.x-25,p.position.y-25,50,50):
			p.play("splat")
			splat = true
	
func _ready():
	p = $p/PlayerSprite
	s = $s/FridgeSprite
	p.play("run")
	s.play("run")
	p.position = vars.p1
	s.position = vars.p2
	dir = vars.dir

func inrect(pos,x,y,width,height):
	return pos.x < x+width and pos.x > x and pos.y < y+height and pos.y > y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if p != null:
		if !splat:
			upd(delta,p)
		else:
			if p.frame == 2:
				p.stop()
				p.frame = 2
		upd(delta,s)
		vars.p1 = p.position
		vars.p2 = s.position 
		vars.dir = dir
		
		if !splat:
			p.flip_h = true if dir == -1 else false
	
	
func upd(delta, t):
	t.position.x += (100  * delta * dir)
	if t.position.x > 600:
		t.position.x = -200
	if t.position.x < -200:
		t.position.x = 600





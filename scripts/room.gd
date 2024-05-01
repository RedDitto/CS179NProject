extends Node2D

var num_enemies = 0

@onready var tilemap: TileMap = get_node("TileMap2")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")


# Called when the node enters the scene tree for the first time.
func _ready():
	num_enemies = enemy_positions_container.get_child_count()
	#_open_doors()

func _on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _open_doors():
	for door in door_container.get_children():
		door.open()

func _close_entrance():
	for entry_position in entrance.get_children():
		tilemap.set_cell(0,tilemap.local_to_map(entry_position.position),0, Vector2i(1,20))

func _spawn_enemies():
	num_enemies = 1
	_on_enemy_killed()

func _on_player_detector_body_entered(body):
	print("working")
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



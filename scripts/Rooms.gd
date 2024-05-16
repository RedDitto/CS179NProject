extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Scenes/spawnroom1.tscn"), preload("res://Scenes/spawnroom2.tscn")]
const ENEMY_ROOMS: Array = [preload("res://Scenes/room1.tscn"), preload("res://Scenes/room2.tscn"), preload("res://Scenes/room3.tscn"), preload("res://Scenes/finroom1.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/endroom1.tscn")]

const TILE_SIZE: int = 16

# left wall tile Vector2i(0,19)
# floor tile Vector2i(1,19)
# right wall Vector2i(2,19)

@export var num_levels: int = 5

@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_rooms()

func _spawn_rooms():
	var previous_room
	var room
	for i in num_levels:
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawn").position
		
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room = ENEMY_ROOMS[randi() % ENEMY_ROOMS.size()].instantiate()
			
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP
		
			var corridor_height: int = randi() % 5 + 3
		
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y),0, Vector2i(0,19))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y), 0, Vector2i(1,19))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y), 0, Vector2i(2,19))
				
			corridor_height = corridor_height + 2
			var room_tilemap = room.get_node("TileMap")
			room.position = Vector2(-8, 0) + previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D").position).x * TILE_SIZE
		add_child(room)
		previous_room = room
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

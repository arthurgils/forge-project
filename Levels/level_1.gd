extends Node2D

@export var level_data: LevelData

func _ready():
	var tilemap = $TileMapLayer_Ground
	var used = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	
	var camera = $Player/Camera2D
	
	camera.limit_left = used.position.x * tile_size.x
	camera.limit_top = used.position.y * tile_size.y
	camera.limit_right = (used.position.x + used.size.x) * tile_size.x
	camera.limit_bottom = (used.position.y + used.size.y) * tile_size.y

extends Node2D

@export var chunk_size := 512
@export var render_distance := 2

@export var ground_scenes: Array[PackedScene] = []
@onready var ground_layer = $GroundLayer

var enemy_scene = preload("res://Scenes/enemy.tscn")

var loaded_chunks := {}
var player_ref = null

func _ready():
	player_ref = get_parent().get_node("Player")
	_update_chunks()

func _process(delta):
	_update_chunks()

func _update_chunks():
	if not player_ref:
		return
	
	var player_chunk = Vector2i(
		floor(player_ref.global_position.x / chunk_size),
		floor(player_ref.global_position.y / chunk_size)
	)
	
	for x in range(player_chunk.x - render_distance, player_chunk.x + render_distance + 1):
		for y in range(player_chunk.y - render_distance, player_chunk.y + render_distance + 1):
			var chunk_key = Vector2i(x, y)
			if not loaded_chunks.has(chunk_key):
				_generate_chunk(chunk_key)
				
	# opcional: remover chunks muito distantes
	#var chunks_to_remove = []
	#for chunk in loaded_chunks.keys():
		#if chunk.distance_to(player_chunk) > render_distance + 1:
			#for node in loaded_chunks[chunk]:
				#node.queue_free()
			#chunks_to_remove.append(chunk)
	#for chunk in chunks_to_remove:
		#loaded_chunks.erase(chunk)

func _generate_chunk(chunk_pos: Vector2i):
	var chunk_nodes = []
	
	var seed = int(chunk_pos.x * 92821 + chunk_pos.y * 68917)
	var ground_seed = int(chunk_pos.x * 92821 + chunk_pos.y * 68917)
	var rng = RandomNumberGenerator.new()
	var rng_ground = RandomNumberGenerator.new()
	rng.seed = seed
	rng_ground.seed = ground_seed
	
	var tile_size = 32
	var tiles_x = int(chunk_size / tile_size)
	var tiles_y = int(chunk_size / tile_size)
	
	for tx in range(tiles_x):
		for ty in range(tiles_y):
			var ground_scene = ground_scenes.pick_random()
			var tile = ground_scene.instantiate()
			var tile_pos = Vector2(
				chunk_pos.x * chunk_size + tx * tile_size,
				chunk_pos.y * chunk_size + ty * tile_size
			)
			tile.global_position = tile_pos
			ground_layer.call_deferred("add_child", tile)
	
	var enemy_count = rng.randi_range(1, 3) #quantity
	for i in enemy_count:
		var enemy = enemy_scene.instantiate()
		var offset = Vector2(
			rng.randf_range(0, chunk_size),
			rng.randf_range(0, chunk_size)
		)
		enemy.global_position = Vector2(chunk_pos) * chunk_size + offset
		get_parent().call_deferred("add_child", enemy)
		chunk_nodes.append(enemy)
	
	loaded_chunks[chunk_pos] = chunk_nodes
	print("Generate chunk: ", chunk_pos)

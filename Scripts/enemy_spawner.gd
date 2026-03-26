extends Node2D

@export var game_manager: GameManager
@export var level: Node2D

var level_data: LevelData

var spawn_timer = 0.0

func _ready():
	level_data = level.level_data

func _process(delta):
	if game_manager.phase_finished:
		return

	spawn_timer -= delta
	var spawn_rate = _get_current_spawn_rate()

	if spawn_timer <= 0.0:
		spawn_timer = spawn_rate
		try_spawn_enemy()


func _get_current_spawn_rate() -> float:
	var t = game_manager.elapsed_time / game_manager.current_level.duration
	return max(
		game_manager.current_level.base_spawn_rate - t * game_manager.current_level.spawn_rate_decrease,
		0.4
	)


func try_spawn_enemy():
	var available = game_manager.current_level.enemies.filter(
		func(e): return e.spawn_after <= game_manager.elapsed_time
	)

	if available.is_empty():
		return

	var enemy_scene = preload("res://Scenes/enemy_base.tscn")
	var enemy = enemy_scene.instantiate()

	var enemy_data = available.pick_random()
	enemy.enemy_data = enemy_data

	enemy.global_position = get_spawn_position()
	get_tree().current_scene.add_child(enemy)


func get_spawn_position() -> Vector2:
	var cam = get_viewport().get_camera_2d()
	var size = get_viewport().get_visible_rect().size
	var center = cam.global_position
	var margin = 100

	var side = randi() % 4
	match side:
		0: return center + Vector2(randf_range(-size.x/2, size.x/2), -size.y/2 - margin)
		1: return center + Vector2(randf_range(-size.x/2, size.x/2), size.y/2 + margin)
		2: return center + Vector2(-size.x/2 - margin, randf_range(-size.y/2, size.y/2))
		3: return center + Vector2(size.x/2 + margin, randf_range(-size.y/2, size.y/2))
	return center

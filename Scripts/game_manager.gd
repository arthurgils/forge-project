extends Node2D
class_name GameManager

signal game_won
signal boss_spawned(boss_instance)
signal boss_health_changed(current_hp: float, max_hp: float)

@export var current_level: LevelData

var elapsed_time = 0.0
var phase_finished = false
var boss_spawned_flag = false
var boss_instance = null

func _ready():
	add_to_group("GameManager")


func _process(delta):
	if phase_finished:
		return

	elapsed_time += delta

	if elapsed_time >= current_level.duration:
		finish_phase()

	if not boss_spawned_flag and current_level.boss_data != null:
		if elapsed_time >= current_level.boss_spawn_time:
			boss_spawned_flag = true
			_spawn_boss()


func _spawn_boss():
	var boss_scene = preload("res://Scenes/enemy_base.tscn")
	var boss = boss_scene.instantiate()
	boss.enemy_data = current_level.boss_data

	var cam = get_viewport().get_camera_2d()
	var size = get_viewport().get_visible_rect().size
	var center = cam.global_position if cam else Vector2.ZERO
	boss.global_position = center + Vector2(size.x / 2 + 150, 0)

	boss.died.connect(_on_boss_died)
	boss.health_changed.connect(_on_boss_health_changed)

	get_tree().current_scene.add_child(boss)
	boss_instance = boss
	emit_signal("boss_spawned", boss)


func _on_boss_died():
	boss_instance = null
	phase_finished = true
	emit_signal("game_won")


func _on_boss_health_changed(current_hp: float, max_hp: float):
	emit_signal("boss_health_changed", current_hp, max_hp)


func finish_phase():
	if phase_finished:
		return
	phase_finished = true
	print("finished")
	if current_level.boss_data == null:
		emit_signal("game_won")

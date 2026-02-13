extends Resource
class_name LevelData

@export var level_name = "Market Street"
@export var duration = 180.0 
@export var enemies: Array[EnemyData] = []

@export var base_spawn_rate = 1.5
@export var spawn_rate_decrease = 0.3 
@export var max_enemies = 25

@export var module_drop_chance = 0.25

@export var boss_scene: PackedScene

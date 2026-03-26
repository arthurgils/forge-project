extends Resource
class_name EnemyData

@export var enemy_name: String = 'Basic'
@export var sprite_frames: SpriteFrames
@export var sprite: Texture2D
@export var sprite_scale: float = 1.0

@export var health: float = 100.0
@export var speed: float = 60.0
@export var damage: float = 5.0

@export var xp_drop: float = 5.0
@export var module_drop_chance: float = 0.1
@export var modules_pool: Array[WeaponModule] = []

@export var spawn_after: float = 0.0

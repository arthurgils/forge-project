extends Resource
class_name ThrowableData

@export var throwable_name = "Basic"
@export var icon: Texture2D

@export var projectile_scene: PackedScene

@export var throw_speed: float = 400.0
@export var cooldown: float = 2.0
@export var max_stack: int = 3

@export var explosion_radius: float = 0.0
@export var damage: float = 0.0
@export var smoke_duration: float = 0.0

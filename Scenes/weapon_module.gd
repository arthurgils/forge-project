extends Resource

class_name WeaponModule

@export var module_name: String = "default"
@export var description: String = "deafult"
@export var rarity: int = 0 # 0 comum, 1 raro, 2 épico, 3 lendário

@export var damage_mult: float = 1.0
@export var projectiles_add: int = 0
@export var spread_add: float = 0.0
@export var fire_rate_mult: float = 1.0

@export var icon: Texture2D

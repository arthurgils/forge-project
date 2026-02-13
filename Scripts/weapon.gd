extends Node2D

#Shot Configs
@export var shot_scene = preload("res://Scenes/shot.tscn")
@onready var fire_timer: Timer = $FireTimer

@export var fire_cadence: float = 1.5
@export var projectiles: int = 1
@export var spread_deg: float = 0.0
@export var damage: float = 5.0
@export var projectiles_speed: float = 200.0

@export var fork_count = 0
@export var fork_angle = 0.0

@export var pierce_count = 0

var modules: Array[WeaponModule] = []

func fire(owner: Node2D, target: Node2D):

	var direction = (target.global_position - owner.global_position).normalized()

	for i in range(projectiles):
		var angle_offset = 0.0
		
		if projectiles > 1:
			var t = 0.0
			t = float(i) / float(projectiles - 1) # 0..1
			angle_offset = deg_to_rad(spread_deg * (t - 0.5) * 2.0)
		
		var dir = direction.rotated(angle_offset)
		
		var shot = shot_scene.instantiate()
		shot.global_position = owner.global_position
		shot.direction = dir
		shot.speed = projectiles_speed
		shot.damage = damage
		shot.fork_count = fork_count
		shot.fork_angle = fork_angle
		shot.pierce_count = pierce_count
		
		owner.get_tree().current_scene.add_child(shot)


func apply_module(module: WeaponModule):
	if module not in modules:
		modules.append(module)
		damage *= module.damage_mult
		projectiles += module.projectiles_add
		spread_deg += module.spread_add
		projectiles_speed *= module.fire_rate_mult
		fork_count += module.fork_add
		fork_angle += module.fork_angle_add
		pierce_count += module.pierce_add
		
	

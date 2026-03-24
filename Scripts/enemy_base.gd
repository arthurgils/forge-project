extends CharacterBody2D

@export var enemy_data: EnemyData
var current_health: float
var current_damage: float
var base_speed: float
var current_speed: float
var current_module_drop_chance: float
var current_modules_pool: Array[WeaponModule]

var is_slowed = false

@onready var player_ref = get_parent().get_node("Player")

var player_in_range = false
var xp_scene = preload("res://Scenes/xp.tscn")

func _ready():
	if enemy_data == null:
		push_error('No enemy data.')
		return
		
	if enemy_data.sprite_frames != null:
		$Sprite2D.sprite_frames = enemy_data.sprite_frames

	$Sprite2D.scale = Vector2.ONE * enemy_data.sprite_scale
	
	current_health = enemy_data.health
	current_damage = enemy_data.damage
	current_speed = enemy_data.speed
	current_module_drop_chance = enemy_data.module_drop_chance
	current_modules_pool = enemy_data.modules_pool
	base_speed = enemy_data.speed
	

func _physics_process(delta):
	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * current_speed
	move_and_slide()
	
	update_animation(direction)


func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	var anim_sprite = $Sprite2D

	play_walk(anim_sprite, direction)

var last_direction: Vector2 = Vector2.DOWN

func play_walk(anim_sprite: AnimatedSprite2D, dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		# Movimento horizontal
		anim_sprite.play("walk")
		anim_sprite.flip_h = dir.x < 0


func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()
		player_ref.enemies_killed += 1


func die():
	drop_xp()
	drop_module()
	queue_free()


func drop_xp():
	var xp_instance = xp_scene.instantiate()
	xp_instance.global_position = global_position
	get_tree().current_scene.add_child(xp_instance)


func drop_module():
	if randf() > current_module_drop_chance:
		return
	
	if current_modules_pool.is_empty():
		return
	
	var module = current_modules_pool.pick_random()
	var drop = preload("res://Scenes/module_drop.tscn").instantiate()
	drop.global_position = global_position
	drop.module = module
	get_tree().current_scene.add_child(drop)
	print("droped")


func apply_smoke_effect(state: bool):
	print("smoke state:", state)
	print(current_speed)
	is_slowed = state
	
	if is_slowed:
		current_speed = base_speed * 0.1
		print(current_speed)
	else:
		current_speed = base_speed


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		$Timer.start()
		print("colided")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		$Timer.stop()
		print("out of range")


func _on_timer_timeout():
	if player_in_range:
		player_ref.take_damage(current_damage)

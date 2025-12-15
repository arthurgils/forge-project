extends CharacterBody2D

@export var health = 10
@export var enemy_damage = 10
@export var speed = 50

@export var modules_pool: Array[WeaponModule] = []
@export var drop_chance: float = 0.25

@onready var player_ref = get_parent().get_node("Player")

var player_in_range = false
var xp_scene = preload("res://Scenes/xp.tscn")

func _physics_process(delta):
	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func take_damage(amount: int):
	health -= amount
	if health <= 0:
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
	if randf() > drop_chance:
		return
	
	if modules_pool.is_empty():
		return
	
	var module = modules_pool.pick_random()
	var drop = preload("res://Scenes/module_drop.tscn").instantiate()
	drop.global_position = global_position
	drop.module = module
	get_tree().current_scene.add_child(drop)
	print("droped")
	


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
		player_ref.take_damage(enemy_damage)

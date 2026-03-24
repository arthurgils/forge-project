extends CharacterBody2D

signal xp_changed(xp: float, xp_to_next: float)
signal level_up(new_level: int, xp: float, xp_to_next: float)

#XP Configs
@export var level = 1
@export var xp = 0.0
@export var xp_to_next = 0.0

#Player Configs
@export var speed = 100
@export var health = 100
@export var enemies_killed = 0

#Shot Configs
@onready var fire_timer: Timer = $FireTimer

#Weapon Configs
@onready var weapon = $Weapon

#var shot_scene = preload("res://Scenes/shot.tscn")

func _ready():
	if level == null or level <= 0:
		push_warning("Null level detected. Level set to 1.")
		level = 1
	
	xp_to_next = xp_required_for_level(level)
	
	fire_timer.wait_time = weapon.fire_cadence
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	fire_timer.start()
	
	emit_signal("xp_changed", xp, xp_to_next)
	emit_signal("level_up", level, xp, xp_to_next)


func _process(delta):
	if Input.is_action_just_pressed("Throw"):
		$ThrowableController.try_throw(self)


func _physics_process(delta):
	var input = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()
	velocity = input * speed
	move_and_slide()
	
	update_animation(input)


func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	var anim_sprite = $Sprite2D
	
	if direction == Vector2.ZERO:
		play_idle(anim_sprite)
	else:
		play_walk(anim_sprite, direction)
		

func play_walk(anim_sprite: AnimatedSprite2D, dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		# Movimento horizontal
		anim_sprite.play("walk_side")
		anim_sprite.flip_h = dir.x < 0
	else:
		# Movimento vertical
		if dir.y > 0:
			anim_sprite.play("walk_down")
		else:
			anim_sprite.play("walk_up")


var last_direction: Vector2 = Vector2.DOWN

func play_idle(anim_sprite: AnimatedSprite2D):
	anim_sprite.play("idle")
			
			
	#if Input.is_action_just_pressed("Shoot"):
		#print("fire")
		#fire()

# === MANUAL SHOOT ===

#func fire():
	#var shot = shot_scene.instantiate()
	#shot.global_position = global_position
	#
	#var direction = (get_global_mouse_position() - global_position).normalized()
	#shot.direction = direction
	#
	#get_tree().current_scene.add_child(shot)
	#

# === AUTOMATIC SHOOT ===

func _on_fire_timer_timeout():
	var enemy = get_nearest_enemy()
	if enemy == null:
		return
	weapon.fire(self, enemy)


func get_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.is_empty():
		return null
	
	var nearest_enemy: Node2D = null
	var nearest_dist := INF
	
	for enemy in enemies:
		if not enemy is Node2D:
			continue
			
		if not _is_enemy_on_screen(enemy):
			continue
		
		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_enemy = enemy
	
	return nearest_enemy


func _get_camera_rect() -> Rect2:
	var viewport := get_viewport()
	var cam := viewport.get_camera_2d()
	if cam == null:
		# Se não tiver câmera ativa, ignora filtro
		return Rect2(-INF, -INF, INF * 2.0, INF * 2.0)
	
	var visible_size := viewport.get_visible_rect().size
	var half := visible_size * 0.5
	var center := cam.global_position
	return Rect2(center - half, visible_size)


func _is_enemy_on_screen(enemy: Node2D) -> bool:
	var cam_rect := _get_camera_rect()
	return cam_rect.has_point(enemy.global_position)


func xp_required_for_level(level: int) -> float:
	var base = 40.0
	var factor = 12.0
	return base + factor * (level*level)


func add_xp(amount: float):
	xp += amount
	
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = xp_required_for_level(level)
		emit_signal("level_up", level, xp, xp_to_next)
	
	emit_signal("xp_changed", xp, xp_to_next)


func take_damage(amount: float):
	health -= amount
	if health <= 0:
		get_tree().quit()
		

extends Area2D

@export var damage: float = 5.0
@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

@export var fork_count: int = 0
@export var fork_angle: float = 0.0

@export var pierce_count: int = 0


func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta


# Need to change 
func _on_body_entered(body: Node) -> void:
	print(pierce_count)
	if not body.is_in_group("Enemies"):
		return

	body.take_damage(damage)
	
	if fork_count > 0:
		fork(body)
	
	if pierce_count <= 0:
		queue_free()
	
	pierce_count -= 1


func fork(enemy: Node):
	var next_fork = fork_count - 1
	
	if next_fork < 0:
		return
	
	var shot_radius = get_shot_radius()
	var enemy_radius: float
	
	if enemy.has_node("CollisionShape2D"):
		var shape = enemy.get_node("CollisionShape2D").shape
		if shape is CircleShape2D:
			enemy_radius = shape.radius
		elif shape is RectangleShape2D:
			enemy_radius = max(shape.size.x, shape.size.y) * 0.25
			
	var offset_distance = enemy_radius + (shot_radius * 0.25) + 2.0
	
	for i in range(2):
		var new_shot = preload("res://Scenes/shot.tscn").instantiate()

		var angle_offset = deg_to_rad(fork_angle)
		if i == 0:
			angle_offset *= -1
		
		var rotated_dir = direction.rotated(angle_offset)
		
		new_shot.global_position = global_position + rotated_dir * offset_distance
		new_shot.direction = rotated_dir
		new_shot.fork_count = next_fork
		new_shot.fork_angle = fork_angle
		new_shot.damage = damage
		new_shot.speed = speed
		
		get_tree().current_scene.add_child(new_shot)


func get_shot_radius() -> float:
	var shape = $CollisionShape2D.shape
	if shape is CircleShape2D:
		return shape.radius
	elif shape is RectangleShape2D:
		return max(shape.size.x, shape.size.y) * 0.5
	return 8.0

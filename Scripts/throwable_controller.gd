extends Node
class_name ThrowableController

@export var equipped_throwable: ThrowableData

var current_stack: int = 10
var cooldown_timer: float = 0.0
var max_stack: int = 10

func _ready():
	current_stack = max_stack

func _process(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta

func try_throw(owner: Node2D):
	if equipped_throwable == null:
		print("No throwable equipped")
		return
	
	if current_stack <= 0:
		print("No throwable stack")
		return
	
	if cooldown_timer > 0:
		print("On cooldown")
		return
	
	throw(owner)
	current_stack -= 1
	cooldown_timer = equipped_throwable.cooldown


func throw(owner: Node2D):
	print("throw")
	var projectile = equipped_throwable.projectile_scene.instantiate()
	print(projectile)
	projectile.global_position = owner.global_position
	
	var direction = (owner.get_global_mouse_position() - owner.global_position).normalized()
	
	projectile.direction = direction
	projectile.speed = equipped_throwable.throw_speed
	projectile.throwable_data = equipped_throwable
	
	owner.get_tree().current_scene.add_child(projectile)

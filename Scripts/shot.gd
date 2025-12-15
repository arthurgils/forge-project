extends Area2D

@export var damage: float = 5.0
@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta


# Need to change 
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
		queue_free()

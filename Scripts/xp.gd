extends Area2D

@export var xp_amount = 10

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_xp(xp_amount)
	queue_free()

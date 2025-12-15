extends Area2D

class_name ModuleDrop

@export var module: WeaponModule

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.weapon.apply_module(module)
		queue_free()

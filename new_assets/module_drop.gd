extends Area2D

class_name ModuleDrop

@export var module: WeaponModule

func _ready():
	if module.icon != null:
		$Sprite2D.texture = module.icon
		$Sprite2D.scale = Vector2(0.4, 0.4)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.weapon.apply_module(module)
		queue_free()

extends Area2D

var direction: Vector2
var speed: float
var throwable_data: ThrowableData

var has_activated = false

func _physics_process(delta):
	if has_activated:
		return
		
	global_position += direction * speed * delta


func _on_body_entered(body):
	if has_activated:
		return
	
	activate_smoke()


func activate_smoke():
	print("ACTIVATING SMOKE")
	has_activated = true
	
	var smoke = preload("res://Scenes/smoke_area.tscn").instantiate()
	smoke.global_position = global_position
	smoke.duration = throwable_data.smoke_duration
	
	get_tree().current_scene.add_child(smoke)
	
	queue_free()

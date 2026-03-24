extends Area2D

var duration = 0.0

func _ready():
	$Timer.wait_time = duration
	$Timer.start()
	$AnimatedSprite2D.play("smoke")


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	print("smoke enter: ", body)
	if body.is_in_group("Enemies"):
		body.apply_smoke_effect(true)


func _on_body_exited(body):
	if body.is_in_group("Enemies"):
		body.apply_smoke_effect(false)

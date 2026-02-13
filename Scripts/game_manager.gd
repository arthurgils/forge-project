extends Node2D
class_name GameManager

@export var current_level: LevelData

var elapsed_time = 0.0
var phase_finished = false

func _process(delta):
	if phase_finished:
		return
		
	elapsed_time += delta
	
	if elapsed_time >= current_level.duration:
		finish_phase()
		

func finish_phase():
	phase_finished = true
	print("finished")
	#stop spawn
	#show UI endgame
	#next level

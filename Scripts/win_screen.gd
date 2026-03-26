extends CanvasLayer

@onready var time_label = $Panel/VBox/TimeLabel
@onready var kills_label = $Panel/VBox/KillsLabel


func _ready():
	hide()
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		gm.game_won.connect(_on_game_won)


func _on_game_won():
	var gm = get_tree().get_first_node_in_group("GameManager")
	var player = get_parent().get_node_or_null("Player")

	if gm:
		var t := int(gm.elapsed_time)
		time_label.text = "Tempo: %02d:%02d" % [t / 60, t % 60]

	if player:
		kills_label.text = "Inimigos abatidos: %d" % player.enemies_killed

	show()


func _on_restart_pressed():
	get_tree().reload_current_scene()

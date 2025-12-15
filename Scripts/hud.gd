extends CanvasLayer

@onready var level_label = $Level
@onready var xp_bar_label = $XpBar
@onready var health_bar_label = $Health
@onready var timer_label = $Timer
@onready var kills_label = $Kills

var elapsed_time: float = 0.0
@onready var player = get_parent().get_node("Player")

func _ready():
	
	if player:
		player.xp_changed.connect(_on_player_xp_changed)
		player.level_up.connect(_on_player_level_up)
	timer_label.text = "00:00"

func _process(delta):
	health_bar_label.text = "Health: " + str(player.health)
	kills_label.text = str(player.enemies_killed)
	elapsed_time += delta
	_update_timer_label()


func _on_player_xp_changed(xp: float, xp_to_next: float):
	xp_bar_label.max_value = xp_to_next
	xp_bar_label.value = xp
	
	
func _on_player_level_up(new_level: int, xp: float, xp_to_next: float):
	level_label.text = "Level: " + str(new_level)
	_on_player_xp_changed(xp, xp_to_next)


func _update_timer_label():
	var total_seconds := int(elapsed_time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

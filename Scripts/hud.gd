extends CanvasLayer

@onready var level_label = $Level
@onready var xp_bar_label = $XpBar
@onready var health_bar_label = $Health
@onready var timer_label = $Timer
@onready var kills_label = $Kills
@onready var boss_bar = $BossBar
@onready var boss_name_label = $BossName

var elapsed_time: float = 0.0
@onready var player = get_parent().get_node("Player")

func _ready():
	if player:
		player.xp_changed.connect(_on_player_xp_changed)
		player.level_up.connect(_on_player_level_up)

	timer_label.text = "00:00"
	boss_bar.hide()
	boss_name_label.hide()

	var gm = get_parent().get_node_or_null("GameManager")
	if gm:
		gm.boss_spawned.connect(_on_boss_spawned)
		gm.boss_health_changed.connect(_on_boss_health_changed)
		gm.game_won.connect(_on_game_won)


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


func _on_boss_spawned(boss):
	boss_name_label.text = boss.enemy_data.enemy_name
	boss_bar.max_value = boss.enemy_data.health
	boss_bar.value = boss.enemy_data.health
	boss_bar.show()
	boss_name_label.show()


func _on_boss_health_changed(current_hp: float, max_hp: float):
	boss_bar.max_value = max_hp
	boss_bar.value = current_hp


func _on_game_won():
	boss_bar.hide()
	boss_name_label.hide()

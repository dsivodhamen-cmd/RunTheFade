extends Control

var stat_reset = 0
# Varriable storing the value for the stat reset

@onready var p1_stats_label = $P1Stats
@onready var p2_stats_label = $P2Stats
# A varriable storing p1 and p2 stats in a label


func _ready() -> void:
	var p1 = GameStats.stats["p1"]
	var p2 = GameStats.stats["p2"]
# A varabile storing the GameStats of the two players

	p1_stats_label.text = "Kills: %d\nDamage done: %d\nDamage taken: %d\nDamage blocked: %d\nParries: %d\nDeaths: %d" % [p1.Kills, 
	p1.Damage_done, p1.Damage_taken, p1.Damage_blocked, p1.Parries, p1.Deaths]
	
	p2_stats_label.text = "Kills: %d\nDamage done: %d\nDamage taken: %d\nDamage blocked: %d\nParries: %d\nDeaths: %d" % [p2.Kills, 
	p2.Damage_done, p2.Damage_taken, p2.Damage_blocked, p2.Parries, p2.Deaths]
# Puts the players stats into text in the labels

func _continue() -> void:
	for player in GameStats.stats:
		for stat in GameStats.stats[player]:
			GameStats.stats[player][stat] = stat_reset
# A for loop going through each player and stat in the GameStats and reseting them back to 0
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
# When the user presses the continue button they will be returned to to main menuu

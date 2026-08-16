extends Node2D

var maps = [
	preload("res://scenes/map_1.tscn"),
	preload("res://scenes/map_2.tscn"),
	preload("res://scenes/map_3.tscn"),
	preload("res://scenes/map_4.tscn"),
	preload("res://scenes/map_5.tscn"),
	preload("res://scenes/map_6.tscn"),
	preload("res://scenes/map_7.tscn")
]
# creates a varaible that store all maps and preloads them in a list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	randomize()
# creates a randomize function

	var random_map = maps.pick_random()
# picks a random map out of the list and stores it in a varaible
	var map_instance = random_map.instantiate()
# creates that map in the game and stores it in an varaible.

	$Map.add_child(map_instance)
# puts the map into the "Map" node so that it can be seen in games

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

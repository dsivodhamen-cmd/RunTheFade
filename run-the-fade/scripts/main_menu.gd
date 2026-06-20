extends Control

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.flip_h = true
# flips the player 2 sprite so that it faces the player 1 sprite

func _play() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
# when the player presses the play button they will get sent to the game

func _quit() -> void:
	get_tree().quit()
# when the player presses the quit button they will exit the game


func _options() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/options_menu.tscn")

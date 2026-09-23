extends Control

@onready var help_doc = $"Help doc"


func _play() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
# When the player presses the play button they will get sent to the game


func _quit() -> void:
	get_tree().quit()
# When the player presses the quit button they will exit the game


func _options() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/options_menu.tscn")
# When the player presses the options button, it changes the scene to the options menu


func _on_help_doc_button_pressed() -> void:
	help_doc.visible = true
# When the player press the help button the help doc will become visible
